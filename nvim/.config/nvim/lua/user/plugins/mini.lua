return {
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		depependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		-- keys = {
		-- 	"<leader>ef",
		-- 	"<cmd>lua MiniFiles.open()<cr>",
		-- 	desc = "list files",
		-- },
		config = function()
			-- Better Around/Inside textobjects
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })
			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
			require("mini.notify").setup({
				content = {
					format = nil,
					sort = nil,
				},
				lsp_progress = {
					enable = false,
				},
				window = {
					config = {},
					max_width_share = 0.382,
					winblend = 25,
				},
			})
		end,
	},
}
