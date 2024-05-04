--          ╭─────────────────────────────────────────────────────────╮
--          │                         Plugins                         │
--          ╰─────────────────────────────────────────────────────────╯
require("lazy").setup({
	-- I'm not sure how much these categories make sense but lets see
	require("user.plugins.ai"), -- copilot, copilot_cmp, copilot chat
	require("user.plugins.cmp"), -- nvim-cmp
	require("user.plugins.debug"), -- trouble and dap stuff
	require("user.plugins.files"), -- neo-tree and telescope
	require("user.plugins.fmt"), -- linting, formatting, other misc text editing
	require("user.plugins.lsp"), -- lsp servers, treesitter
	require("user.plugins.tools"), -- harpoon, mini, gitsigns, neorg
	require("user.plugins.ui"), -- theme, barbar, dashboar, lualine, whichkey
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
