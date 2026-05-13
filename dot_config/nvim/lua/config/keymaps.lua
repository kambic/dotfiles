-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- DIRECTORY NAVIGATION ------------------------------------------------------
keymap.set("n", "<leader>m", ":NvimTreeFocus<CR>", opts)
keymap.set("n", "<leader>f", ":NvimTreeToggle<CR>", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts) -- NAVIGATE [^] UP
keymap.set("n", "<C-h>", "<C-w>h", opts) -- NAVIGATE [<] LEFT
keymap.set("n", "<C-l>", "<C-w>l", opts) -- NAVIGATE [>] RIGHT
keymap.set("n", "<C-j>", "<C-w>j", opts) -- NAVIGATE [v] DOWN

-- WINDOW MANAGEMENT ---------------------------------------------------------
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts) -- SPLIT VERTICALLY
keymap.set("n", "<leader>sh", ":split<CR>", opts) -- SPLIT HORIZONTALLY

-- INDENT --------------------------------------------------------------------
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- COMMENTS ------------------------------------------------------------------
vim.api.nvim_set_keymap("n", "<C-_>", "gcc", { noremap = false })
vim.api.nvim_set_keymap("v", "<C-_>", "gcc", { noremap = false })
