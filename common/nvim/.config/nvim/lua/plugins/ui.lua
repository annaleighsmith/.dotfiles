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
	bg_light = "#434c5e",
	none = "NONE",
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
					RainbowDelimiterGreen = { fg = colors.green },
					RainbowDelimiterCyan = { fg = colors.cyan },
					RainbowDelimiterBlue = { fg = colors.blue },
					RaibowDelimiterViolet = { fg = colors.purple },
					SnacksDashboardHeader = { fg = colors.green },
					SnacksDashboardKey = { fg = colors.cyan },
					SnacksDashboardIcon = { fg = colors.cyan },
					SnacksDashboardDesc = { fg = colors.cyan },
					SnacksDashboardFooter = { fg = colors.light_purple },
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
			local ibl_colors = {
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
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = ibl_colors.red })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = ibl_colors.yellow })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = ibl_colors.blue })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = ibl_colors.orange })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = ibl_colors.green })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = ibl_colors.cyan })
			end)

			vim.g.rainbow_delimiters = { highlight = highlight }
			require("ibl").setup({
				exclude = {
					filetypes = {
						"help",
						"alpha",
						"snacks_dashboard",
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
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			notifier = { enabled = true },
			dashboard = {
				preset = {
					header = table.concat({
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
						"              ( |_____________|/___               ",
						"          .=======================.\\              ",
						"          | ::::::::::::::::  ::: | \\             ",
						"          | ::::::::::::::[]  ::: |  \\            ",
						"          |   -----------     ::: |   (|)         ",
						"          '-----------------------'   [ ]        ",
					}, "\n"),
					keys = {
						{ icon = "󱞳 ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
						{ icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files hidden=true" },
						{ icon = "󰈭 ", key = "w", desc = "Find Word", action = ":Telescope live_grep" },
						{ icon = "󰇚 ", key = "l", desc = "Lazy", action = ":Lazy home" },
						{ icon = " ", key = "h", desc = "Check Health", action = ":checkhealth" },
						{ icon = " ", key = "q", desc = "Quit", action = ":q" },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
		},
	},

	{
		"Bekaboo/deadcolumn.nvim",
		opts = {
			blending = {
				threshold = 0.1,
				colorcode = colors.yellow,
				hlgroup = { "Normal", "bg" },
			},
			warning = {
				alpha = 0.4,
				offset = 0,
				colorcode = colors.red,
				hlgroup = { "Error", "bg" },
			},
		},
	},
	{
		"echasnovski/mini.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local map = require("mini.map")
			map.setup({
				symbols = {
					encode = map.gen_encode_symbols.dot("4x2"),
				},
				integrations = {
					map.gen_integration.builtin_search(),
					map.gen_integration.gitsigns(),
					map.gen_integration.diagnostic(),
				},
				window = {
					focusable = false,
					side = "right",
					width = 7,
					winblend = 50,
					show_integration_count = false,
					wo = {
						number = false,
						relativenumber = false,
					},
				},
			})
			vim.keymap.set("n", "<leader>tm", function()
				map.toggle()
			end, { desc = "Toggle Mini Map" })
			-- Auto-open on buffer enter
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				callback = function()
					local ft = vim.bo.filetype
					local excluded = {
						"snacks_dashboard",
						"neo-tree",
						"help",
						"Trouble",
						"trouble",
						"lazy",
						"mason",
						"notify",
						"toggleterm",
						"oil",
					}
					for _, v in ipairs(excluded) do
						if ft == v then
							return
						end
					end
					map.open()
				end,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "echasnovski/mini.nvim" },
		config = function()
			local theme = require("lualine.themes.auto")
			for _, mode in pairs(theme) do
				if mode.b then
					mode.b.bg = "NONE"
				end
				if mode.c then
					mode.c.bg = "NONE"
				end
			end
			require("lualine").setup({
				options = {
					theme = theme,
					icons_enabled = true,
					section_separators = { "", "" },
					component_separators = { "", "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{
							"filename",
							path = 1,
							file_status = true,
							newfile_status = false,
							shorting_target = 40,
							symbols = {
								modified = "[+]",
								readonly = "[-]",
								unnamed = "[No Name]",
								newfile = "[New]",
							},
						},
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			require("which-key").add({
				{ "<leader>b", group = "Buffer" },
				{ "<leader>c", group = "Code" },
				{ "<leader>e", group = "Explore", icon = " " },
				{ "<leader>g", group = "GitHunk" },
				{ "<leader>h", group = "Harpoon", icon = " " },
				{ "<leader>l", group = "LSP", icon = " " },
				{ "<leader>s", group = "Search" },
				{ "<leader>t", group = "Toggle" },
				{ "<leader>h", desc = "Git Hunk", mode = "v" },
			})
		end,
	},
}
