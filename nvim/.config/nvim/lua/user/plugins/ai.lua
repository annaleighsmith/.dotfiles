return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			filetypes = {
				["*"] = true,
			},
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"zbirenbaum/copilot.lua",
		},
		opts = {
			debug = true,
		},
		keys = {
			{
				"<leader>tC",
				":CopilotChatToggle<CR>",
				mode = "n",
				desc = "toggle copilot chat window",
			},
		},
	},
}
