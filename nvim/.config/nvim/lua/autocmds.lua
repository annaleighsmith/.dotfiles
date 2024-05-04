--          ╭─────────────────────────────────────────────────────────╮
--          │                      Autocommands                       │
--          ╰─────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_user_command("CopilotToggle", function()
	if copilot_on then
		vim.cmd("Copilot disable")
		print("Copilot OFF")
	else
		vim.cmd("Copilot enable")
		print("Copilot ON")
	end
	copilot_on = not copilot_on
end, { nargs = 0 })

-- Google Python Formatting
local maxoff = 50 -- maximum number of lines to look backwards.
function get_google_python_indent(lnum)
	-- Indent inside parens.
	-- Align with the open paren unless it is at the end of the line.
	-- E.g.
	--   open_paren_not_at_EOL(100,
	--                         (200,
	--                          300),
	--                         400)
	--   open_paren_at_EOL(
	--       100, 200, 300, 400)
	vim.api.nvim_win_set_cursor(0, { lnum, 1 })
	local par_line, par_col = vim.fn.searchpairpos(
		"(|{|[",
		"",
		")|}|]",
		"bW",
		'line(".") < '
			.. (lnum - maxoff)
			.. ' ? "" : '
			.. 'synIDattr(synID(line("."), col("."), 1), "name")'
			.. ' =~ "\\(Comment\\|String\\)$"'
	)
	if par_line > 0 then
		vim.api.nvim_win_set_cursor(0, { par_line, 1 })
		if par_col ~= vim.fn.col("$") - 1 then
			return par_col
		end
	end

	-- Delegate the rest to the original function.
	return vim.fn.GetPythonIndent(lnum)
end
