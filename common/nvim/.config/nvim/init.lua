--          ╭─────────────────────────────────────────────────────────╮
--          │                        init.lua                         │
--          ╰─────────────────────────────────────────────────────────╯

-- ── Global variables ────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- ── Modules ─────────────────────────────────────────────────────────
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lazy-bootstrap")
require("core.lazy-plugins")
