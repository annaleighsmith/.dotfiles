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
		config = function()
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.tabline").setup()
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
		"gbprod/yanky.nvim",
		dependencies = { "kkharji/sqlite.lua" },
		opts = {
			ring = { storage = "sqlite" },
		},
		keys = {
			{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" },
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
			{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "GPut after" },
			{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "GPut before" },
			{ "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Cycle yank history back" },
			{ "<C-n>", "<Plug>(YankyNextEntry)", desc = "Cycle yank history forward" },
			{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after" },
			{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before" },
			{ "<leader>sy", function() require("telescope").extensions.yank_history.yank_history({}) end, desc = "Search Yank History" },
		},
		config = function(_, opts)
			require("yanky").setup(opts)
			require("telescope").load_extension("yank_history")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
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
}
