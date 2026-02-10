return {
	{
		"mrjones2014/legendary.nvim",
		version = "*",
		priority = 10000,
		lazy = false,
		config = function()
			require("legendary").setup({
				extensions = {
					nvim_tree = true,
					which_key = { auto_register = true },
					lazy_nvim = { auto_register = true },
				},
			})
		end,
	},
	{ "ThePrimeagen/vim-be-good" },
	{ -- Harpoon
		"ThePrimeagen/harpoon",
		lazy = true,
		keys = {
			{
				"<leader>he",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				desc = "Edit marks... (harpoon)",
			},
			{
				"<leader>hh",
				"<cmd>Telescope harpoon marks<cr>",
				desc = "Show marks... (harpoon)",
			},
			{
				"<leader>hm",
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "Mark this file (harpoon)",
			},
		},
		config = function()
			require("telescope").load_extension("harpoon")
		end,
	},

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
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to next git change" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to previous git change" })

				-- Actions
				-- visual mode
				map("v", "<leader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "stage git hunk" })
				map("v", "<leader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "reset git hunk" })
				-- normal mode
				map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "git stage hunk" })
				map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "git reset hunk" })
				map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "git stage buffer" })
				map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "git undo stage hunk" })
				map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "git reset buffer" })
				map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "git preview hunk" })
				map("n", "<leader>gb", gitsigns.blame_line, { desc = "git blame line" })
				map("n", "<leader>gd", gitsigns.diffthis, { desc = "git diff against index" })
				map("n", "<leader>gD", function()
					gitsigns.diffthis("@")
				end, { desc = "git [D]iff against last commit" })
				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "toggle git show blame line" })
				map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "toggle git show deleted" })
			end,
		},
	},
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		version = "*",
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					-- ["core.latex.render"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/notes",
							},
							default_workspace = "notes",
						},
					},
				},
			})

			vim.wo.foldlevel = 99
			vim.wo.conceallevel = 2
		end,
	},
}
