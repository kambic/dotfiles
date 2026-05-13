-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- TAB/INDENT ----------------------------------------------------------------
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- SEARCH --------------------------------------------------------------------
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- APPEARANCE ----------------------------------------------------------------
opt.number = true
opt.relativenumber = false
opt.termguicolors = true
opt.colorcolumn = "100"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 10
opt.completeopt = "menuone,noinsert,noselect"

-- MISC ----------------------------------------------------------------------
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false
opt.modifiable = true
opt.encoding = "UTF-8"

-- APPEND --------------------------------------------------------------------
opt.mouse:append("a")
opt.iskeyword:append("-")
opt.clipboard:append("unnamedplus")

-- ANSIBLE/YAML --------------------------------------------------------------
vim.filetype.add({
  extension = {
    yml = "yaml.ansible",
  },
})
