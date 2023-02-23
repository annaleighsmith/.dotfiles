return {
  {
    "rebelot/kanagawa.nvim",
  },
  {
    "catppuccin/nvim",
  },
  {
    "anna-smith97/nord.nvim",
    config = function()
      vim.cmd([[colorscheme nord]])
      vim.g.nord_contrast = true
      vim.g.nord_italic = false
      vim.g.nord_disable_background = false
      vim.g.nord_bold = true
      vim.g.nord_uniform_diff_background = true
    end,
  },

  { "EdenEast/nightfox.nvim" },

  { "LazyVim/LazyVim", opts = { colorscheme = "nord" } },

  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {},
  },
}
