return {
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "fade_in_slide_out",
      timeout = 7000,
      render = "compact",
      -- vim log levels are "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"
      level = "ERROR",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },
  {
    "ThePrimeagen/harpoon",
    init = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Mark file" })
      vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon Menu" })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        max_name_length = 30,
        max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
        color_icons = false,
        diagnostics = false,
        highlights = {
          buffer_selected = {
            gui = "none",
          },
        },
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "Outline",
            text = "Symbols Outline",
            highlight = "TSType",
            text_align = "left",
          },
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      -- moving cmdline back to the bottom
      cmdline = {
        enabled = true,
        view = "cmdline",
      },
    },
  -- stylua: ignore
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
  },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons

      local function fg(name)
        return function()
          ---@type {foreground?:number}?
          local hl = vim.api.nvim_get_hl_by_name(name, true)
          return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
        end
      end

      local function lsp_name(msg)
        msg = msg or "Inactive"
        local buf_clients = vim.lsp.buf_get_clients()
        if next(buf_clients) == nil then
          if type(msg) == "boolean" or #msg == 0 then
            return "Inactive"
          end
          return msg
        end
        local buf_client_names = {}

        for _, client in pairs(buf_clients) do
          if client.name ~= "null-ls" then
            table.insert(buf_client_names, client.name)
          end
        end

        return table.concat(buf_client_names, ", ")
      end

      opts.sections = vim.tbl_deep_extend("force", opts.sections, {
        lualine_c = {
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
          },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filename", padding = { left = 1, right = 1 } },
          -- stylua: ignore
          {
            function() return require("nvim-navic").get_location() end,
            cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
          },
        },
        lualine_x = {
          {
            lsp_name,
            icon = "",
            color = { gui = "none" },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 1 } },
          { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
        },
      })
    end,
  },

  -- dashboard
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
      ███╗   ██╗ ███████╗  ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗        Z
      ████╗  ██║ ██╔════╝ ██╔═══██╗ ██║   ██║ ██║ ████╗ ████║     Z
      ██╔██╗ ██║ █████╗   ██║   ██║ ██║   ██║ ██║ ██╔████╔██║   Z
      ██║╚██╗██║ ██╔══╝   ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║ z
      ██║ ╚████║ ███████╗ ╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
      ╚═╝  ╚═══╝ ╚══════╝  ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
      ]]
      opts.section.header.val = vim.split(logo, "\n")
      opts.section.buttons.val = {
        dashboard.button("p", " " .. "Open project", "<cmd>Telescope project display_type=full<cr>"),
        dashboard.button("e", " " .. "New file", "<cmd>ene <BAR> startinsert<cr>"),
        dashboard.button("f", " " .. "Find file", "<cmd>cd $HOME/Projects | Telescope find_files<cr>"),
        dashboard.button("r", " " .. "Recent files", "<CMD>Telescope oldfiles<cr>"),
        dashboard.button("s", "勒" .. "Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("g", " " .. "Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. "Config", ":e $MYVIMRC | :cd %:p:h | Telescope file_browser<cr>"),
        dashboard.button("l", "鈴" .. "Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("m", " " .. "Mason", "<cmd>Mason<cr>"),
        dashboard.button("q", " " .. "Quit", "<cmd>qa<cr>"),
      }
      opts.config.opts.setup = function()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          desc = "disable tabline for alpha",
          callback = function()
            vim.opt.showtabline = 0
          end,
        })
        vim.api.nvim_create_autocmd("BufUnload", {
          buffer = 0,
          desc = "enable tabline after alpha",
          callback = function()
            vim.opt.showtabline = 2
          end,
        })
      end
    end,
  },
  -- scrollbar for Neovim
  {
    "dstein64/nvim-scrollview",
    event = "BufReadPre",
    config = {
      excluded_filetypes = { "alpha", "neo-tree" },
      current_only = true,
      winblend = 75,
    },
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = {
      "ToggleTerm",
    },
    config = true,
    keys = {
      {
        "<leader>ti",
        "<cmd>ToggleTerm<cr>",
        desc = "Toggle Terminal",
      },
    },
    opts = {
      terminal_mappings = true,
      direction = "horizontal",
    },
  },
}
