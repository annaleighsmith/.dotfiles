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
require("options")
require("keymaps")
require("lazy-bootstrap")
require("lazy-plugins")
