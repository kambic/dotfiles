return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = require("user.languages").parsers,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
