local Util = require("lazyvim.util")
return {
  -- trying this out
  -- disable mini.bufremove
  { "echasnovski/mini.bufremove", enabled = false },

  -- use bdelete instead
  {
    "famiu/bufdelete.nvim",
    -- stylua: ignore
    config = function()
      -- switches to Alpha dashboard when last buffer is closed
      local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = "BDeletePost*",
        group = alpha_on_empty,
        callback = function(event)
          local fallback_name = vim.api.nvim_buf_get_name(event.buf)
          local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
          local fallback_on_empty = fallback_name == "" and fallback_ft == ""
          if fallback_on_empty then
            require("neo-tree").close_all()
            vim.cmd("Alpha")
            vim.cmd(event.buf .. "bwipeout")
          end
        end,
      })
    end,
    keys = {
      { "<leader>bd", "<CMD>Bdelete<CR>", desc = "delete buffer" },
      { "<leader>bD", "<CMD>Bdelete!<CR>", desc = "delete buffer (force)" },
    },
  },
  -- file explorer
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "ms-jpq/chadtree",
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   cmd = "Neotree",
  --   keys = {
  --     opts = {
  --       close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  --       filesystem = {
  --         bind_to_cwd = false,
  --         follow_current_file = true,
  --         group_empty_dirs = true,
  --         hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
  --       },
  --     },
  --     window = {
  --       mappings = {
  --         ["<space>"] = "none",
  --       },
  --     },
  --   },
  -- },
  -- TELESCOPE!
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-dap.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-project.nvim" },
      { "debugloop/telescope-undo.nvim" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        layout_strategy = "flex",
        layout_config = {
          width = 0.8,
          height = 0.8,
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        winblend = 10,
        mappings = {
          i = {
            ["<C-j>"] = function(...)
              return require("telescope.actions").move_selection_next(...)
            end,
            ["<C-k>"] = function(...)
              return require("telescope.actions").move_selection_previous(...)
            end,
            ["<C-p>"] = function(...)
              return require("telescope.actions.layout").toggle_preview(...)
            end,
          },
          n = {
            ["j"] = function(...)
              return require("telescope.actions").move_selection_next(...)
            end,
            ["k"] = function(...)
              return require("telescope.actions").move_selection_previous(...)
            end,
            ["gg"] = function(...)
              return require("telescope.actions").move_to_top(...)
            end,
            ["G"] = function(...)
              return require("telescope.actions").move_to_bottom(...)
            end,
            ["<C-p>"] = function(...)
              return require("telescope.actions.layout").toggle_preview(...)
            end,
          },
        },
      },
      extensions = {
        project = {
          base_dirs = {
            "~/projects",
          },
        },
        undo = {
          use_delta = true,
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.4,
          },
        },
      },
    },

    keys = {
      {
        "<leader>fp",
        "<CMD>Telescope project display_type=full<CR>",
        desc = "find project",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("dap")
      telescope.load_extension("fzf")
      telescope.load_extension("project")
      telescope.load_extension("undo")
    end,
  },

  {
    "folke/which-key.nvim",
    opts = function()
      require("which-key").register({
        ["<leader>d"] = { name = "+debug", mode = { "n", "v" } },
        ["<leader>ct"] = { name = "+test" },
      })
    end,
  },

  -- git blame
  {
    "f-person/git-blame.nvim",
    event = "BufReadPre",
    config = function()
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_message_template = "  <author>  <date>  <summary>"
      vim.g.gitblame_date_format = "%b %d %Y"
    end,
  },

  -- git conflict
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    config = true,
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = function()
      local icons = require("lazyvim.config").icons
      require("symbols-outline").setup({
        symbols = {
          File = { icon = icons.kinds.File, hl = "TSURI" },
          Module = { icon = icons.kinds.Module, hl = "TSNamespace" },
          Namespace = { icon = icons.kinds.Namespace, hl = "TSNamespace" },
          Package = { icon = icons.kinds.Package, hl = "TSNamespace" },
          Class = { icon = icons.kinds.Class, hl = "TSType" },
          Method = { icon = icons.kinds.Method, hl = "TSMethod" },
          Property = { icon = icons.kinds.Property, hl = "TSMethod" },
          Field = { icon = icons.kinds.Field, hl = "TSField" },
          Constructor = { icon = icons.kinds.Constructor, hl = "TSConstructor" },
          Enum = { icon = icons.kinds.Enum, hl = "TSType" },
          Interface = { icon = icons.kinds.Interface, hl = "TSType" },
          Function = { icon = icons.kinds.Function, hl = "TSFunction" },
          Variable = { icon = icons.kinds.Variable, hl = "TSConstant" },
          Constant = { icon = icons.kinds.Constant, hl = "TSConstant" },
          String = { icon = icons.kinds.String, hl = "TSString" },
          Number = { icon = icons.kinds.Number, hl = "TSNumber" },
          Boolean = { icon = icons.kinds.Boolean, hl = "TSBoolean" },
          Array = { icon = icons.kinds.Array, hl = "TSConstant" },
          Object = { icon = icons.kinds.Object, hl = "TSType" },
          Key = { icon = icons.kinds.Key, hl = "TSType" },
          Null = { icon = icons.kinds.Null, hl = "TSType" },
          EnumMember = { icon = icons.kinds.EnumMember, hl = "TSField" },
          Struct = { icon = icons.kinds.Struct, hl = "TSType" },
          Event = { icon = icons.kinds.Event, hl = "TSType" },
          Operator = { icon = icons.kinds.Operator, hl = "TSOperator" },
          TypeParameter = { icon = icons.kinds.TypeParameter, hl = "TSParameter" },
        },
      })
    end,
  },
  -- {
  --   "folke/zen-mode.nvim",
  --   cmd = "ZenMode",
  --   config = true,
  --   keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  -- },
}
