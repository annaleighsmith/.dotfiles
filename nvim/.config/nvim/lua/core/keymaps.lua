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
vim.keymap.set("n", "<A-,>", "<Cmd>BufferPrevious<CR>", { desc = "Move focus to the previous buffer" })
vim.keymap.set("n", "<A-.>", "<Cmd>BufferNext<CR>", { desc = "Move focus to the next buffer" })
vim.keymap.set("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", { desc = "Re-order to previous buffer" })
vim.keymap.set("n", "<A->>", "<Cmd>BufferMoveNext<CR>", { desc = "Re-order to next buffer" })
vim.keymap.set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", { desc = "Goto buffer in position 1" })
vim.keymap.set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", { desc = "Goto buffer in position 2" })
vim.keymap.set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", { desc = "Goto buffer in position 3" })
vim.keymap.set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", { desc = "Goto buffer in position 4" })
vim.keymap.set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", { desc = "Goto buffer in position 5" })
vim.keymap.set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", { desc = "Goto buffer in position 6" })
vim.keymap.set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", { desc = "Goto buffer in position 7" })
vim.keymap.set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", { desc = "Goto buffer in position 8" })
vim.keymap.set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", { desc = "Goto buffer in position 9" })
vim.keymap.set("n", "<A-0>", "<Cmd>BufferLast<CR>", { desc = "Goto the last buffer" })
vim.keymap.set("n", "<A-p>", "<Cmd>BufferPin<CR>", { desc = "Pin the current buffer" })
vim.keymap.set("n", "<A-c>", "<Cmd>BufferClose<CR>", { desc = "Close the current buffer" })
-- Diagnostic keymaps
vim.keymap.set("n", "<leader>cp", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "<leader>cn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>cm", vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })
