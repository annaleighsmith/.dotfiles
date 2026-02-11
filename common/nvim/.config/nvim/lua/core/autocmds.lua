--          ╭─────────────────────────────────────────────────────────╮
--          │                      Autocommands                       │
--          ╰─────────────────────────────────────────────────────────╯

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#EBCB8B", fg = "#2E3440" })
		vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 300 })
	end,
})
