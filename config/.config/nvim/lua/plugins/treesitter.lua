return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false, -- keep it loaded on startup for consistent highlighting
  priority = 100, -- make sure it loads early
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      vim.notify("nvim-treesitter not found", vim.log.levels.ERROR)
      return
    end

    configs.setup({
      ensure_installed = {
        "lua",
        "c",
        "javascript",
        "python",
        "bash",
        "json",
        "yaml",
        "html",
        "css",
        "vim",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    })
  end,
}
