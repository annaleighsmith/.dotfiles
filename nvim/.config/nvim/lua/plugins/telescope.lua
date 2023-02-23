return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "flex",
        layout_config = {
          width = 0.8,
          height = 0.8,
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        winblend = 10,
      },
    },
  },
}
