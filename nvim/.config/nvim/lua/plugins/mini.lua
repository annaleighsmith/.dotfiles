return {
  {
    "echasnovski/mini.map",
    opts = {},
    keys = {
      --stylua: ignore
      { "<leader>vm", function() require("mini.map").toggle {} end, desc = "Toggle Minimap", },
    },
    config = function(_, opts)
      require("mini.map").setup(opts)
    end,
  },
  {
    "echasnovski/mini.move",
    opts = {},
    keys = { "<M-h>", "<M-l>", "<M-j>", "<M-k>" },
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },
  -- add minimap to buffer
  -- {
  --   "gorbit99/codewindow.nvim",
  --   -- event = "BufReadPre",
  --   event = "VeryLazy",
  --   auto_enable = false,
  --   config = function()
  --     local codewindow = require("codewindow")
  --     codewindow.setup({
  --       active_in_terminals = false, -- Should the minimap activate for terminal buffers
  --       auto_enable = true, -- Automatically open the minimap when entering a (non-excluded) buffer (accepts a table of filetypes)
  --       exclude_filetypes = { "alpha", "neo-tree", "Outline", "dap-terminal" }, -- Choose certain filetypes to not show minimap on
  --       max_minimap_height = nil, -- The maximum height the minimap can take (including borders)
  --       max_lines = nil, -- If auto_enable is true, don't open the minimap for buffers which have more than this many lines.
  --       minimap_width = 20, -- The width of the text part of the minimap
  --       use_lsp = true, -- Use the builtin LSP to show errors and warnings
  --       use_treesitter = true, -- Use nvim-treesitter to highlight the code
  --       use_git = true, -- Show small dots to indicate git additions and deletions
  --       width_multiplier = 4, -- How many characters one dot represents
  --       z_index = 1, -- The z-index the floating window will be on
  --       show_cursor = true, -- Show the cursor position in the minimap
  --       window_border = "none", -- The border style of the floating window (accepts all usual options)
  --     })
  --     codewindow.apply_default_keybinds()
  --   end,
  --   keys = {
  --     {
  --       "<leader>um",
  --       function()
  --         require("codewindow").toggle_minimap()
  --       end,
  --       desc = "Toggle Minimap",
  --     },
  --   },
  -- },
  -- {
  --   "echasnovski/mini.ai",
  --   keys = {
  --     { "a", mode = { "x", "o" } },
  --     { "i", mode = { "x", "o" } },
  --   },
  --   dependencies = {
  --     {
  --       "nvim-treesitter/nvim-treesitter-textobjects",
  --       init = function()
  --         -- no need to load the plugin, since we only need its queries
  --         require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
  --       end,
  --     },
  --   },
  --   opts = function()
  --     local ai = require("mini.ai")
  --     return {
  --       n_lines = 500,
  --       custom_textobjects = {
  --         o = ai.gen_spec.treesitter({
  --           a = { "@block.outer", "@conditional.outer", "@loop.outer" },
  --           i = { "@block.inner", "@conditional.inner", "@loop.inner" },
  --         }, {}),
  --         f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
  --         c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
  --       },
  --     }
  --   end,
  --   config = function(_, opts)
  --     local ai = require("mini.ai")
  --     ai.setup(opts)
  --   end,
  -- },
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    enabled = false,
    config = function(_, _)
      require("mini.animate").setup()
    end,
  },
  -- {
  --   "echasnovski/mini.pairs",
  --   event = "VeryLazy",
  --   config = function(_, opts)
  --     require("mini.pairs").setup(opts)
  --   end,
  -- },
}
