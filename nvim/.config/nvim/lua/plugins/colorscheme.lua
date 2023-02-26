return {
  -- disable LazyVim builtin colorschemes
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },

  -- colorschmes ive tried but dont want right now
  -- { "rebelot/kanagawa.nvim" },
  -- { "EdenEast/nightfox.nvim" },

  { "rmehri01/onenord.nvim" },

  -- for some reason I forked this theme
  -- did not see any easy way to change bg darker
  -- leaving installed despite changing to onenord in case of other deps
  {
    "anna-smith97/nord.nvim",
    config = function()
      -- vim.cmd([[colorscheme nord]])
      vim.g.nord_contrast = true
      vim.g.nord_italic = false
      vim.g.nord_disable_background = false
      vim.g.nord_bold = true
      vim.g.nord_uniform_diff_background = true
    end,
  },

  -- { "LazyVim/LazyVim", opts = { colorscheme = "nord" } },
  -- This plugin adds highlights for text filetypes, like markdown, orgmode, and neorg.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local colors = require("onenord.colors").load()
        require("onenord").setup({
          theme = "dark", -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
          borders = true, -- Split window borders
          fade_nc = true, -- Fade non-current windows, making them more distinguishable
          -- Style that is applied to various groups: see `highlight-args` for options
          styles = {
            comments = "NONE",
            strings = "NONE",
            keywords = "NONE",
            functions = "NONE",
            variables = "NONE",
            diagnostics = "underline",
          },
          disable = {
            background = false, -- Disable setting the background color
            cursorline = true, -- Disable the cursorline
            eob_lines = true, -- Hide the end-of-buffer lines
          },
          -- Inverse highlight for different groups
          inverse = {
            match_paren = false,
          },
          custom_highlights = {
            AlphaHeader = { fg = colors.blue },
            AlphaButtons = { fg = colors.green },
            AlphaShortcut = { fg = colors.yellow },
          }, -- Overwrite default highlight groups
          custom_colors = {
            bg = "#22272f", -- default is #2E3440
          }, -- Overwrite default colors
        })
      end,
    },
  },
}
