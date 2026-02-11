--          ╭─────────────────────────────────────────────────────────╮
--          │                         KEYMAPS                         │
--          ╰─────────────────────────────────────────────────────────╯
-- Toggles
vim.keymap.set("", "<leader>tc", ":Copilot toggle<CR>", { desc = "toggle Copilot completions" })
vim.keymap.set("", "<leader>tC", ":CopilotChatToggle<CR>", { desc = "toggle Copilot chat window" })
-- Misc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- Focus
vim.keymap.set("n", "<left>", "<C-w><C-h>", { desc = "Move focus to left window" })
vim.keymap.set("n", "<right>", "<C-w><C-l>", { desc = "Move focus to right window" })
vim.keymap.set("n", "<up>", "<C-w><C-k>", { desc = "Move focus to upper window" })
vim.keymap.set("n", "<down>", "<C-w><C-j>", { desc = "Move focus to lower window" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
-- Buffers
vim.keymap.set("n", "<A-,>", "<Cmd>bprevious<CR>", { desc = "Move focus to the previous buffer" })
vim.keymap.set("n", "<A-.>", "<Cmd>bnext<CR>", { desc = "Move focus to the next buffer" })
vim.keymap.set("n", "<A-c>", "<Cmd>bdelete<CR>", { desc = "Close the current buffer" })
-- Explore
vim.keymap.set("n", "<leader>ee", "<cmd>Ex<CR>", { desc = "Open netrw" })
-- Diagnostic keymaps
vim.keymap.set("n", "<leader>cp", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "<leader>cn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>cm", vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })
