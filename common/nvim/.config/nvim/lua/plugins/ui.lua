local colors = {
	fg = "#C8D0E0",
	fg_light = "#E5E9F0",
	bg = "#2E3440",
	gray = "#646A76",
	light_gray = "#6C7A96",
	cyan = "#88C0D0",
	blue = "#81A1C1",
	dark_blue = "#5E81AC",
	green = "#A3BE8C",
	light_green = "#8FBCBB",
	dark_red = "#BF616A",
	red = "#D57780",
	light_red = "#DE878F",
	pink = "#E85B7A",
	dark_pink = "#E44675",
	orange = "#D08F70",
	yellow = "#EBCB8B",
	purple = "#B988B0",
	light_purple = "#B48EAD",
	none = "NONE",
	bg_light = "#434c5e",
}

return {
	{
		"rmehri01/onenord.nvim",
		priority = 100,
		init = function()
			require("onenord").setup({
				custom_highlights = {
					RainbowDelimiterRed = { fg = colors.red },
					RainbowDelimiterOrange = { fg = colors.orange },
					RainbowDelimiterYellow = { fg = colors.yellow },
					RainbowDelimiterBlue = { fg = colors.blue },
					RainbowDelimiterGreen = { fg = colors.green },
					RainbowDelimiterCyan = { fg = colors.cyan },
					RainbowDelimiterViolet = { fg = colors.purple },
					WhichKey = { fg = colors.green, bold = true },
					WhichKeyGroup = { fg = colors.purple },
					WhichKeyDesc = { fg = colors.fg_light },
					WhichKeyFloat = { bg = colors.bg },
				},
			})
		end,
	},
	{
		"hiphish/rainbow-delimiters.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VimEnter",
		config = function()
			-- Define colors first
			local colors = {
				red = "#E06C75",
				yellow = "#E5C07B",
				blue = "#61AFEF",
				orange = "#D19A66",
				green = "#98C379",
				cyan = "#56B6C2",
			}

			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = colors.red })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = colors.yellow })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = colors.blue })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = colors.orange })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = colors.green })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = colors.cyan })
			end)

			vim.g.rainbow_delimiters = { highlight = highlight }
			require("ibl").setup({
				exclude = {
					filetypes = {
						"help",
						"alpha",
						"dashboard",
						"neo-tree",
						"Trouble",
						"trouble",
						"lazy",
						"mason",
						"notify",
						"toggleterm",
						"lazyterm",
					},
				},
			})
		end,
	},
	{ -- tab bar at top of the screen
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			animation = true,
			icons = {
				button = "",
				preset = "default",
			},
		},
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},
	{
		"MaximilianLloyd/ascii.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				theme = "doom",
				config = {
					header = {
						"                    ______________                ",
						"                   /             /|               ",
						"                  /             / |               ",
						"                 /____________ /  |               ",
						"                | ___________ |   |               ",
						"                ||  *    *   ||   |               ",
						"                ||    vi     ||   |               ",
						"                ||  -....-   ||   |               ",
						"                ||___________||   |               ",
						"                |   _______   |  /                ",
						"               /|  (_______)  | /                 ",
						"              ( |_____________|/                  ",
						"          .=======================.              ",
						"          | ::::::::::::::::  ::: |              ",
						"          | ::::::::::::::[]  ::: |              ",
						"          |   -----------     ::: |              ",
						"          \\-----------------------'              ",
						"          																     ",
						"          																     ",
						"          																     ",
					},
					center = {
						{
							icon = "  ",
							desc = "Recently opened files                   ",
							action = "Telescope oldfiles",
							key = "o",
						},
						{
							icon = "  ",
							desc = "Find File                               ",
							action = "Telescope find_files hidden=true",
							key = "f",
						},
						{
							icon = "  ",
							desc = "Find Word                               ",
							action = "Telescope live_grep",
							key = "w",
						},
						{
							icon = "󰇚  ",
							desc = "Lazy                                    ",
							action = "Lazy home",
							key = "l",
						},
						-- check health
						{
							icon = "  ",
							desc = "Check Health                           ",
							action = "checkhealth",
							key = "h",
						},
						{ icon = "  ", desc = "Quit                                    ", action = ":q", key = "q" },
					},
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},

	{
		"Bekaboo/deadcolumn.nvim",
		opts = {
			blending = {
				threshold = 0.1,
				colorcode = "#EBCB8B",
				hlgroup = { "Normal", "bg" },
			},
			warning = {
				alpha = 0.4,
				offset = 0,
				colorcode = "#E06C75",
				hlgroup = { "Error", "bg" },
			},
		},
	},
	{
		"petertriho/nvim-scrollbar",
		dependencies = { "lewis6991/gitsigns.nvim" },
		opts = {
			excluded_filetypes = {
				"dashboard",
				"neo-tree",
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
			},
			hide_if_all_visible = true,
			marks = {
				Cursor = {
					text = " ",
					priority = 99,
				},
			},
			handle = {
				blend = 20,
				higlight = "Cursor",
			},
			handlers = {
				gitsigns = true,
				cursor = true,
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "auto",
				icons_enabled = true,
				section_separators = { "", "" },
				component_separators = { "", "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				-- lualine_c = { "filename" },
				lualine_c = {
					{
						"filename",
						path = 1,
						file_status = true, -- Displays file status (readonly status, modified status)
						newfile_status = false, -- Display new file status (new file means no write after created)
						shorting_target = 40, -- Shortens path to leave 40 spaces in the window
						symbols = {
							modified = "[+]", -- Text to show when the file is modified.
							readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for newly created file before first write
						},
					},
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			presets = {
				bottom_search = true,
				lsp_doc_border = true,
				long_message_to_split = true,
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
		},
		config = function()
			require("noice").setup({
				cmdline = {
					view = "cmdline",
				},
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			-- "rcarriga/nvim-notify",
		},
	},
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function()
			require("which-key").register({
				{ "<leader>b", group = "Buffer" },
				{ "<leader>b_", hidden = true },
				{ "<leader>c", group = "Code" },
				{ "<leader>c_", hidden = true },
				{ "<leader>e", group = "Tree" },
				{ "<leader>e_", hidden = true },
				{ "<leader>g", group = "GitHunk" },
				{ "<leader>g_", hidden = true },
				{ "<leader>h", group = "Harpoon" },
				{ "<leader>h_", hidden = true },
				{ "<leader>l", group = "LSP" },
				{ "<leader>l_", hidden = true },
				{ "<leader>r", group = "Rename" },
				{ "<leader>r_", hidden = true },
				{ "<leader>s", group = "Search" },
				{ "<leader>s_", hidden = true },
				{ "<leader>t", group = "Toggle" },
				{ "<leader>t_", hidden = true },
				{ "<leader>h", desc = "Git Hunk", mode = "v" },
			})
		end,
	},
}
