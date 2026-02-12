#!/usr/bin/env lua

local json = require("dkjson")

-- Convert "#RRGGBB" to truecolor ANSI foreground escape
local function hex(s)
	local r, g, b = s:match("#(%x%x)(%x%x)(%x%x)")
	return string.format("\027[38;2;%d;%d;%dm", tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
end
-- #B48EAD
local colors = {
	reset = "\027[0m",
	model = hex("#88C0D0"), -- model name
	icon_model = hex("#B48EAD"), -- model icon
	icon_dir = hex("#88C0D0"), -- folder icon
	icon_branch = hex("#9EC183"), -- git branch icon
	icon_uncommitted = hex("#E06C75"), -- uncommitted icon
	icon_ahead = hex("#EBCB8B"), -- ahead arrow icon
	icon_behind = hex("#EBCB8B"), -- behind arrow icon
	icon_message = hex("#B988B0"), -- chat bubble icon
	text = hex("#E5E9F0"), -- default text
	sep = hex("#E5E9F0"), -- separator
	bar_fill = hex("#88C0D0"), -- filled bar segments
	bar_empty = hex("#4C566A"), -- empty bar segments
}

local sep = "|"

-- Nerd Font icons (Unicode escapes so the file stays ASCII-safe)
local icons = {
	model = "\u{ee9c}", -- add your icon
	dir = "\u{f07b} ", -- nf-fa-folder
	branch = "\u{e725} ", -- nf-dev-git_branch
	uncommitted = " \u{f12a}", -- nf-fa-exclamation
	ahead = " \u{f01e}", -- nf-fa-repeat (original)
	behind = " \u{f0e2}", -- nf-fa-undo (original)
	message = "\u{f075} ", -- nf-fa-comment
}

-- Strip ANSI escape sequences for visual-width measurement
local function strip_ansi(s)
	return s:gsub("\027%[[%d;]*m", "")
end

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
			bar[#bar + 1] = colors.bar_fill .. "█" .. colors.reset
		elseif progress >= 3 then
			bar[#bar + 1] = colors.bar_fill .. "▄" .. colors.reset
		else
			bar[#bar + 1] = colors.bar_empty .. "░" .. colors.reset
		end
	end
	return table.concat(bar)
end

-- Format a time difference as human-readable
local function format_ago(diff)
	if diff <= 0 then
		return "<1m ago"
	elseif diff < 60 then
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
	-- Single git call: branch, upstream, ahead/behind, and file status
	local porcelain =
		run(string.format("git -C %q --no-optional-locks status --porcelain=v2 --branch 2>/dev/null", cwd))

	if porcelain ~= "" then
		local file_count = 0
		local ahead, behind = 0, 0
		local has_upstream = false

		for line in porcelain:gmatch("[^\n]+") do
			if line:match("^# branch%.head ") then
				branch = line:match("^# branch%.head (.+)") or ""
			elseif line:match("^# branch%.ab ") then
				local a, b = line:match("^# branch%.ab %+(%d+) %-(%d+)")
				ahead = tonumber(a) or 0
				behind = tonumber(b) or 0
				has_upstream = true
			elseif line:match("^# branch%.upstream ") then
				has_upstream = true
			elseif not line:match("^#") then
				file_count = file_count + 1
			end
		end

		if branch ~= "" and branch ~= "(detached)" then
			local sync_status
			if has_upstream then
				if ahead == 0 and behind == 0 then
					-- Only check fetch time when synced (no need to stat otherwise)
					local fetch_ago = ""
					local fetch_head = cwd .. "/.git/FETCH_HEAD"
					local fh = io.open(fetch_head, "r")
					if fh then
						fh:close()
						local fetch_time = tonumber(run(string.format(
							"stat -f %%m %q 2>/dev/null || stat -c %%Y %q 2>/dev/null",
							fetch_head, fetch_head)))
						if fetch_time then
							fetch_ago = format_ago(os.time() - fetch_time)
						end
					end
					sync_status = fetch_ago ~= "" and ("synced " .. fetch_ago) or "synced"
				elseif ahead > 0 and behind == 0 then
					sync_status = colors.text .. string.format("%d", ahead) .. colors.icon_ahead .. icons.ahead
				elseif ahead == 0 and behind > 0 then
					sync_status = colors.text .. string.format("%d", behind) .. colors.icon_behind .. icons.behind
				else
					sync_status = colors.text
						.. string.format("%d", ahead)
						.. colors.icon_ahead
						.. icons.ahead
						.. " "
						.. colors.text
						.. string.format("%d", behind)
						.. colors.icon_behind
						.. icons.behind
				end
			else
				sync_status = "no upstream"
			end

			-- Build git status string
			local parts = {}
			if file_count > 0 then
				parts[#parts + 1] = colors.text
					.. string.format("%d", file_count)
					.. colors.icon_uncommitted
					.. icons.uncommitted
			end
			if sync_status ~= "synced" and sync_status ~= "no upstream" and not sync_status:match("^synced ") then
				parts[#parts + 1] = sync_status
			end
			if #parts > 0 then
				git_status = table.concat(parts, " ")
			end
		end
	end
end

-- 20k baseline: system prompt (~3k), tools (~15k), memory (~300), plus dynamic context
local baseline = 20000

-- Read only the tail of the transcript (last 200 lines is plenty for recent usage + last user msg)
local transcript_lines = {}
if transcript_path ~= "" then
	local h = io.popen(string.format("tail -n 200 %q 2>/dev/null", transcript_path), "r")
	if h then
		for line in h:lines() do
			local obj = json.decode(line)
			if obj then
				transcript_lines[#transcript_lines + 1] = obj
			end
		end
		h:close()
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

local ctx = string.format("%s %s%s%d%% / %dk", draw_bar(pct), colors.text, pct_prefix, pct, max_k)

local usage = " " .. colors.sep .. sep .. " " .. hex("#B48EAD") .. "69k"

-- Build main output line
local mi = icons.model ~= "" and (colors.icon_model .. icons.model .. " ") or ""
local output = mi
	.. colors.model
	.. model
	.. " "
	.. colors.sep
	.. sep
	.. " "
	.. colors.icon_dir
	.. icons.dir
	.. " "
	.. colors.text
	.. dir
if branch ~= "" then
	output = output
		.. " "
		.. colors.sep
		.. sep
		.. " "
		.. colors.icon_branch
		.. icons.branch
		.. " "
		.. colors.text
		.. branch
	if git_status ~= "" then
		output = output .. " " .. git_status
	end
end
output = output .. " " .. colors.sep .. sep .. " " .. ctx .. usage .. colors.reset

io.write(output .. "\n")

-- Last user message (second line)
if #transcript_lines > 0 then
	-- Calculate max display length from a plain version of the status line
	local plain = model .. " " .. sep .. " x " .. dir
	if branch ~= "" then
		plain = plain .. " " .. sep .. " x " .. branch
		if git_status ~= "" then
			plain = plain .. " " .. strip_ansi(git_status)
		end
	end
	plain = plain .. " " .. sep .. " xxxxxxxxxx " .. pct .. "% / " .. max_k .. "k"
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
				and not text:find("<local-command-stdout>", 1, true)
				and not text:find("<local-command-caveat>", 1, true)
				and not text:find("<command-name>", 1, true)
			then
				last_user_msg = text
				break
			end
		end
	end

	if last_user_msg ~= "" then
		if #last_user_msg > max_len then
			io.write(
				" "
					.. colors.icon_message
					.. icons.message
					.. colors.text
					.. last_user_msg:sub(1, max_len - 4)
					.. "...\n"
			)
		else
			io.write(" " .. colors.icon_message .. icons.message .. colors.text .. last_user_msg .. "\n")
		end
	end
end
