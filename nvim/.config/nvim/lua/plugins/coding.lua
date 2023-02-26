-- equivalant to coding module

return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "comment",
      "diff",
      "dot",
      "make",
      "help",
      "html",
      "javascript",
      "json",
      "lua",
      "rust",
      "markdown",
      "markdown_inline",
      "python",
      "vim",
      "json",
      "jsonc",
      "yaml",
      "QML",
    },
  },
  -- tidy
  {
    "mcauley-penney/tidy.nvim",
    event = "VeryLazy",
    config = {
      filetype_exclude = { "markdown", "diff" },
    },
  },
  -- editor config support
  {
    "editorconfig/editorconfig-vim",
    event = "VeryLazy",
  },
  -- scopes
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    config = true,
  },
  -- This plugin adds highlights for text filetypes, like markdown, orgmode, and neorg.
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {},
  },
  -- other weird languages I need syntax highlighing through a plugin for
  {
    "elkowar/yuck.vim",
  },
  {
    "peterhoeg/vim-qml",
    event = "BufRead",
    ft = { "qml" },
  },
  -- highlight colors in code
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  -- copilot and copilot cmp
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    config = true,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    event = "VeryLazy",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      -- add copilot as a cmp source
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "copilot" } }))
      -- copied from appelgriebsch, think it will help will diabling arrow keys
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      })
    end,
  },
}
