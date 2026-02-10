--          ╭─────────────────────────────────────────────────────────╮
--          │                         Plugins                         │
--          ╰─────────────────────────────────────────────────────────╯
require("lazy").setup({
	-- I'm not sure how much these categories make sense but lets see
	require("plugins.ai"), -- copilot, copilot_cmp, copilot chat
	require("plugins.cmp"), -- nvim-cmp
	require("plugins.debug"), -- trouble and dap stuff
	require("plugins.files"), -- neo-tree and telescope
	require("plugins.fmt"), -- linting, formatting, other misc text editing
	require("plugins.lsp"), -- lsp servers, treesitter
	require("plugins.tools"), -- harpoon, mini, gitsigns
	require("plugins.ui"), -- theme, barbar, dashboar, lualine, whichkey
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
