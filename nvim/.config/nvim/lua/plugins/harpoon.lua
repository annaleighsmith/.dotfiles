return {
  {
    "ThePrimeagen/harpoon",
    init = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Mark file" })
      vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon Menu" })
    end,
  },
}
