return { -- Harpoon
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
}
