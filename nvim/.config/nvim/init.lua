--          ╭─────────────────────────────────────────────────────────╮
--          │                        init.lua                         │
--          ╰─────────────────────────────────────────────────────────╯

-- ── Global variables ────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.g.pyindent_nested_paren = "&sw*2"
vim.g.pyindent_open_paren = "&sw*2"

-- ── Modules ─────────────────────────────────────────────────────────
require("core.options")
require("core.keymaps")
require("core.lazy-bootstrap")
require("core.lazy-plugins")
