-- [[ Setting options ]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.colorcolumn = "80"
-- vim.opt.listchars = { tab = "│─", trail = "·", nbsp = "‿" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.cmdheight = 0
vim.opt.hlsearch = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Set arrow keys to move between windows
vim.keymap.set("n", "<left>", "<C-w><C-h>", { desc = "Move focus to left window" })
vim.keymap.set("n", "<right>", "<C-w><C-l>", { desc = "Move focus to right window" })
vim.keymap.set("n", "<up>", "<C-w><C-k>", { desc = "Move focus to upper window" })
vim.keymap.set("n", "<down>", "<C-w><C-j>", { desc = "Move focus to lower window" })
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- barbar mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)
-- Re-order to previous/next
map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
-- Goto buffer in position...
map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
-- Close buffer
map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_user_command("CopilotToggle", function()
	if copilot_on then
		vim.cmd("Copilot disable")
		print("Copilot OFF")
	else
		vim.cmd("Copilot enable")
		print("Copilot ON")
	end
	copilot_on = not copilot_on
end, { nargs = 0 })

local maxoff = 50 -- maximum number of lines to look backwards.

function get_google_python_indent(lnum)
	-- Indent inside parens.
	-- Align with the open paren unless it is at the end of the line.
	-- E.g.
	--   open_paren_not_at_EOL(100,
	--                         (200,
	--                          300),
	--                         400)
	--   open_paren_at_EOL(
	--       100, 200, 300, 400)
	vim.api.nvim_win_set_cursor(0, { lnum, 1 })
	local par_line, par_col = vim.fn.searchpairpos(
		"(|{|[",
		"",
		")|}|]",
		"bW",
		'line(".") < '
			.. (lnum - maxoff)
			.. ' ? "" : '
			.. 'synIDattr(synID(line("."), col("."), 1), "name")'
			.. ' =~ "\\(Comment\\|String\\)$"'
	)
	if par_line > 0 then
		vim.api.nvim_win_set_cursor(0, { par_line, 1 })
		if par_col ~= vim.fn.col("$") - 1 then
			return par_col
		end
	end

	-- Delegate the rest to the original function.
	return vim.fn.GetPythonIndent(lnum)
end

vim.g.pyindent_nested_paren = "&sw*2"
vim.g.pyindent_open_paren = "&sw*2"

-- vim.keymap.set("n", "<up>", "<C-w><C-k>", { desc = "Move focus to upper window" })
vim.keymap.set("", "<leader>tc", ":CopilotToggle<CR>", { desc = "toggle copilot completions" })

require("lazy").setup({
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{ "numToStr/Comment.nvim", opts = {} },
	{ "ThePrimeagen/vim-be-good" },
	{
		"norcalli/nvim-colorizer.lua",
		-- enable automatically
		config = function()
			require("colorizer").setup()
		end,
		opts = {},
	},
	{
		"Bekaboo/deadcolumn.nvim",
		opts = {
			blending = {
				threshold = 0.1,
				colorcode = "#EBCB8B",
				hlgroup = { "Normal", "bg" },
			},
			warning = {
				alpha = 0.4,
				offset = 0,
				colorcode = "#E06C75",
				hlgroup = { "Error", "bg" },
			},
		},
	},
	{ import = "user.plugins" },
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
