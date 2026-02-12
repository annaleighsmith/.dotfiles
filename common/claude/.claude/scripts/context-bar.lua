#!/usr/bin/env lua

local json = require("dkjson")

-- Nord/OneNord color palette
local c = {
	reset = "\027[0m",
	accent = "\027[38;5;116m", -- nord8 cyan (#88C0D0)
	gray = "\027[38;5;245m", -- muted text
	bar_empty = "\027[38;5;238m", -- near-background
}

-- Nerd Font icons
local icons = {
	dir = " ",      -- nf-fa-folder
	branch = " ",   -- nf-dev-git_branch
	uncommitted = " ", -- nf-fa-pencil
	ahead = " ",     -- nf-fa-arrow_up
	behind = " ",    -- nf-fa-arrow_down
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
local cwd = input.cwd or ""
local transcript_path = input.transcript_path or ""
local max_context = (input.context_window and input.context_window.context_window_size) or 200000

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
			git_status = "(" .. table.concat(parts, " ") .. ")"
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

-- Build main output line
local output = c.accent .. model .. c.gray .. " | " .. icons.dir .. dir
if branch ~= "" then
	output = output .. " | " .. icons.branch .. branch
	if git_status ~= "" then
		output = output .. " " .. git_status
	end
end
output = output .. " | " .. ctx .. c.reset

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
