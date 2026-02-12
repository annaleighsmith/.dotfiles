#!/usr/bin/env lua

local json = require("dkjson")

-- ── Configuration ──────────────────────────────────────────────
-- Daily output token limit for your plan (used for % calculation)
-- Pro ≈ 1M, Max 5x ≈ 5M (adjust to match your actual limits)
local DAILY_TOKEN_LIMIT = 1000000
local STATS_PATH = os.getenv("HOME") .. "/.claude/stats-cache.json"
-- ───────────────────────────────────────────────────────────────

-- Convert "#RRGGBB" to truecolor ANSI foreground escape
local function hex(s)
	local r, g, b = s:match("#(%x%x)(%x%x)(%x%x)")
	return string.format("\027[38;2;%d;%d;%dm", tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
end

-- Nord/OneNord color palette
local c = {
	reset = "\027[0m",
	accent = hex("#88C0D0"), -- nord8 cyan
	gray = hex("#8a8a8a"), -- muted text
	bar_empty = hex("#444444"), -- near-background
}

-- Nerd Font icons
local icons = {
	dir = " ",
	branch = " ",
	uncommitted = " ",
	ahead = "  ",
	behind = "  ",
}

-- Run a shell command and return trimmed stdout
local function run(cmd)
	local h = io.popen(cmd, "r")
	if not h then
		return ""
	end
	local out = h:read("*a") or ""
	h:close()
	return out:match("^%s*(.-)%s*$") or ""
end

-- Draw a 10-segment context bar for a given percentage
local function draw_bar(pct)
	local bar = {}
	for i = 0, 9 do
		local bar_start = i * 10
		local progress = pct - bar_start
		if progress >= 8 then
			bar[#bar + 1] = c.accent .. "█" .. c.reset
		elseif progress >= 3 then
			bar[#bar + 1] = c.accent .. "▄" .. c.reset
		else
			bar[#bar + 1] = c.bar_empty .. "░" .. c.reset
		end
	end
	return table.concat(bar)
end

-- Format a time difference as human-readable
local function format_ago(diff)
	if diff < 60 then
		return "<1m ago"
	elseif diff < 3600 then
		return string.format("%dm ago", math.floor(diff / 60))
	elseif diff < 86400 then
		return string.format("%dh ago", math.floor(diff / 3600))
	else
		return string.format("%dd ago", math.floor(diff / 86400))
	end
end

-- Parse input JSON from stdin
local input_raw = io.read("*a") or "{}"
local input = json.decode(input_raw) or {}

local model = (input.model and (input.model.display_name or input.model.id)) or "?"
local model_id = (input.model and input.model.id) or ""
local cwd = input.cwd or ""
local transcript_path = input.transcript_path or ""
local max_context = (input.context_window and input.context_window.context_window_size) or 200000

-- Pricing per million tokens (USD)
local pricing = {
	["claude-opus-4-6"] = { input = 15, output = 75, cache_read = 1.50, cache_write = 18.75 },
	["claude-sonnet-4-5-20250929"] = { input = 3, output = 15, cache_read = 0.30, cache_write = 3.75 },
	["claude-haiku-4-5-20251001"] = { input = 0.25, output = 1.25, cache_read = 0.025, cache_write = 0.3125 },
}

local dir = cwd:match("[^/]+$") or "?"
local max_k = math.floor(max_context / 1000)

-- Git info
local branch = ""
local git_status = ""

if cwd ~= "" then
	branch = run(string.format("git -C %q branch --show-current 2>/dev/null", cwd))

	if branch ~= "" then
		-- Count uncommitted files
		local porcelain = run(string.format("git -C %q --no-optional-locks status --porcelain 2>/dev/null", cwd))
		local file_count = 0
		local first_file = ""
		for line in porcelain:gmatch("[^\n]+") do
			file_count = file_count + 1
			if file_count == 1 then
				first_file = line:sub(4)
			end
		end

		-- Sync status with upstream
		local sync_status
		local upstream = run(string.format("git -C %q rev-parse --abbrev-ref @{upstream} 2>/dev/null", cwd))

		if upstream ~= "" then
			-- Last fetch time
			local fetch_ago = ""
			local fetch_head = cwd .. "/.git/FETCH_HEAD"
			local fh = io.open(fetch_head, "r")
			if fh then
				fh:close()
				local fetch_time = tonumber(
					run(
						string.format(
							"stat -f %%m %q 2>/dev/null || stat -c %%Y %q 2>/dev/null",
							fetch_head,
							fetch_head
						)
					)
				)
				if fetch_time then
					local now = os.time()
					fetch_ago = format_ago(now - fetch_time)
				end
			end

			local counts =
				run(string.format("git -C %q rev-list --left-right --count HEAD...@{upstream} 2>/dev/null", cwd))
			local ahead, behind = counts:match("(%d+)%s+(%d+)")
			ahead = tonumber(ahead) or 0
			behind = tonumber(behind) or 0

			if ahead == 0 and behind == 0 then
				sync_status = fetch_ago ~= "" and ("synced " .. fetch_ago) or "synced"
			elseif ahead > 0 and behind == 0 then
				sync_status = string.format("%d%s", ahead, icons.ahead)
			elseif ahead == 0 and behind > 0 then
				sync_status = string.format("%d%s", behind, icons.behind)
			else
				sync_status = string.format("%d%s%d%s", ahead, icons.ahead, behind, icons.behind)
			end
		else
			sync_status = "no upstream"
		end

		-- Build git status string
		local parts = {}
		if file_count > 0 then
			parts[#parts + 1] = string.format("%d%s", file_count, icons.uncommitted)
		end
		if sync_status ~= "synced" and sync_status ~= "no upstream" and not sync_status:match("^synced ") then
			parts[#parts + 1] = sync_status
		end
		if #parts > 0 then
			git_status = table.concat(parts, " ")
		end
	end
end

-- 20k baseline: system prompt (~3k), tools (~15k), memory (~300), plus dynamic context
local baseline = 20000

-- Read transcript once
local transcript_lines = {}
if transcript_path ~= "" then
	local fh = io.open(transcript_path, "r")
	if fh then
		for line in fh:lines() do
			local obj = json.decode(line)
			if obj then
				transcript_lines[#transcript_lines + 1] = obj
			end
		end
		fh:close()
	end
end

-- Calculate context usage from transcript
local pct, pct_prefix
if #transcript_lines > 0 then
	-- Find last message with usage that isn't sidechain or error
	local context_length = 0
	for i = #transcript_lines, 1, -1 do
		local entry = transcript_lines[i]
		if entry.message and entry.message.usage and not entry.isSidechain and not entry.isApiErrorMessage then
			local u = entry.message.usage
			context_length = (u.input_tokens or 0)
				+ (u.cache_read_input_tokens or 0)
				+ (u.cache_creation_input_tokens or 0)
			break
		end
	end

	if context_length > 0 then
		pct = math.floor(context_length * 100 / max_context)
		pct_prefix = ""
	else
		pct = math.floor(baseline * 100 / max_context)
		pct_prefix = "~"
	end
else
	pct = math.floor(baseline * 100 / max_context)
	pct_prefix = "~"
end

if pct > 100 then
	pct = 100
end

local ctx = string.format("%s %s%s%d%% / %dk", draw_bar(pct), c.gray, pct_prefix, pct, max_k)

-- Calculate session cost from transcript
local session_cost = 0
local price = pricing[model_id]
if price and #transcript_lines > 0 then
	for _, entry in ipairs(transcript_lines) do
		if entry.message and entry.message.usage and not entry.isSidechain and not entry.isApiErrorMessage then
			local u = entry.message.usage
			session_cost = session_cost
				+ (u.input_tokens or 0) * price.input / 1e6
				+ (u.output_tokens or 0) * price.output / 1e6
				+ (u.cache_read_input_tokens or 0) * price.cache_read / 1e6
				+ (u.cache_creation_input_tokens or 0) * price.cache_write / 1e6
		end
	end
end

-- Daily usage from stats-cache
local daily_pct = ""
local stats_fh = io.open(STATS_PATH, "r")
if stats_fh then
	local stats_raw = stats_fh:read("*a")
	stats_fh:close()
	local stats = json.decode(stats_raw)
	if stats and stats.dailyModelTokens then
		local today = os.date("%Y-%m-%d")
		for _, day in ipairs(stats.dailyModelTokens) do
			if day.date == today and day.tokensByModel then
				local total = 0
				for _, tokens in pairs(day.tokensByModel) do
					total = total + tokens
				end
				if DAILY_TOKEN_LIMIT > 0 then
					local dp = math.floor(total * 100 / DAILY_TOKEN_LIMIT)
					if dp > 100 then dp = 100 end
					daily_pct = string.format("%d%% daily", dp)
				end
				break
			end
		end
	end
end

-- Format cost + daily usage
local usage = ""
if session_cost > 0 or daily_pct ~= "" then
	local parts = {}
	if session_cost > 0 then
		parts[#parts + 1] = string.format("$%.2f", session_cost)
	end
	if daily_pct ~= "" then
		parts[#parts + 1] = daily_pct
	end
	usage = " | " .. c.gray .. table.concat(parts, " ")
end

-- Build main output line
local output = c.accent .. model .. c.gray .. " | " .. icons.dir .. dir
if branch ~= "" then
	output = output .. " | " .. icons.branch .. branch
	if git_status ~= "" then
		output = output .. " " .. git_status
	end
end
output = output .. " | " .. ctx .. usage .. c.reset

io.write(output .. "\n")

-- Last user message (second line)
if #transcript_lines > 0 then
	-- Calculate max display length from a plain version of the status line
	local plain = model .. " | x " .. dir
	if branch ~= "" then
		plain = plain .. " | x " .. branch
		if git_status ~= "" then
			plain = plain .. " " .. git_status
		end
	end
	plain = plain .. " | xxxxxxxxxx " .. pct .. "% / " .. max_k .. "k"
	if session_cost > 0 then
		plain = plain .. " | " .. string.format("$%.2f", session_cost)
	end
	if daily_pct ~= "" then
		plain = plain .. " " .. daily_pct
	end
	local max_len = #plain

	-- Find last real user message, skipping interrupts/system noise
	local last_user_msg = ""
	for i = #transcript_lines, 1, -1 do
		local entry = transcript_lines[i]
		if entry.type == "user" and entry.message and entry.message.content then
			local content = entry.message.content
			local text = ""

			if type(content) == "string" then
				text = content
			elseif type(content) == "table" then
				local parts = {}
				for _, part in ipairs(content) do
					if type(part) == "table" and part.type == "text" then
						parts[#parts + 1] = part.text
					end
				end
				text = table.concat(parts, " ")
			end

			-- Normalize whitespace
			text = text:gsub("\n", " "):gsub("  +", " "):match("^%s*(.-)%s*$") or ""

			-- Skip unhelpful messages
			if
				text ~= ""
				and not text:match("^%[Request interrupted")
				and not text:match("^%[Request cancelled")
				and not text:find("<local%-command%-stdout>", 1, false)
				and not text:find("<local%-command%-caveat>", 1, false)
			then
				last_user_msg = text
				break
			end
		end
	end

	if last_user_msg ~= "" then
		if #last_user_msg > max_len then
			io.write(" " .. last_user_msg:sub(1, max_len - 3) .. "...\n")
		else
			io.write(" " .. last_user_msg .. "\n")
		end
	end
end
