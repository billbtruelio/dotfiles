-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { silent = true, desc = "Save and leave insert mode" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true })
