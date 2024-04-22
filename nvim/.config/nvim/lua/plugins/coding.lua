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
  -- {
  --   "wakatime/vim-wakatime",
  --   event = "BufRead",
  -- },
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
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --     })
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   dependencies = { "zbirenbaum/copilot.lua" },
  --   event = "VeryLazy",
  --   config = function()
  --     require("copilot_cmp").setup({
  --       method = "getCompletionCycling",
  --       formatters = {
  --         insert_text = require("copilot_cmp.format").remove_existing,
  --         -- label = require("copilot_cmp.format").format_label_text,
  --         -- preview = require("copilot_cmp.format").deindent,
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "nvim-cmp",
  --   opts = function(_, opts)
  --     local cmp = require("cmp")
  --     -- add copilot as a cmp source
  --     opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "copilot" } }))
  --     -- copied from appelgriebsch, think it will help will diabling arrow keys
  --     opts.mapping = cmp.mapping.preset.insert({
  --       ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  --       ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  --       ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
  --       ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
  --       ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
  --       ["<C-e>"] = cmp.mapping({
  --         i = cmp.mapping.abort(),
  --         c = cmp.mapping.close(),
  --       }),
  --       -- Accept currently selected item. If none selected, `select` first item.
  --       -- Set `select` to `false` to only confirm explicitly selected items.
  --       ["<Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  --     })
  --   end,
  -- },
  {
    "amarakon/nvim-cmp-buffer-lines",
    event = "InsertEnter",
  },
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp",
      "amarakon/nvim-cmp-buffer-lines",
    },
    opts = function()
      local cmp = require("cmp")
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
          col_offset = -3,
          side_padding = 0,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({

          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<Tab>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),

        sources = cmp.config.sources({
          { name = "copilot", group_index = 2 },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "buffer_lines" },
        }),

        formatting = {
          fields = { "menu", "kind", "abbr" },
          format = function(_, item)
            local icons = require("lazyvim.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        cmdline = {
          border = "single",
          entries = {
            { name = "wildmenu" },
          },
        },

        -- experimental = {
        --   ghost_text = {
        --     hl_group = "LspCodeLens",
        --   },
        -- },
      }
    end,
  },
}
