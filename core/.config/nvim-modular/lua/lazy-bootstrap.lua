-- [[ Install `lazy.nvim` plugin manager ]]
-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)
-------------------------------------------------------
-- 🚀 Plugin setup via Lazy.nvim
-------------------------------------------------------
require('lazy').setup({

  -- Indent detection
  {
    'NMAC427/guess-indent.nvim',
    opts = {
      auto_cmd = true,
      override_editorconfig = true,
    },
  },

  -----------------------------------------------------
  -- 🔔 Notification system
  -----------------------------------------------------
  {
    'rcarriga/nvim-notify',
    lazy = false,
    config = function()
      local notify = require 'notify'
      notify.setup {
        stages = 'fade_in_slide_out',
        timeout = 3000,
        background_colour = '#1a1b26',
        render = 'default',
        top_down = false,
      }
      vim.notify = notify
    end,
  },

  -----------------------------------------------------
  -- 🧩 Your other plugin imports
  -----------------------------------------------------
  { import = 'plugins' },
  require 'extra.lualine',
  require 'extra.bufferline',
  -- require("extra.notify"),
}, {
  -----------------------------------------------------
  -- ⚙️ Lazy.nvim behavior
  -----------------------------------------------------
  defaults = {
    lazy = true,
    version = false,
  },
  install = {
    -- Automatically install missing plugins
    missing = true,
    -- Automatically set colorscheme
    -- colorscheme = { 'onedark' },
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-------------------------------------------------------
-- ✅ Safety fallback if theme fails
-------------------------------------------------------
-- pcall(vim.cmd.colorscheme, theme)
-- vim: ts=2 sts=2 sw=2 et
