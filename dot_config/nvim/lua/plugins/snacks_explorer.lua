return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      -- This setup uses a horizontal box to place the preview on the right
   layout = {
            { preview = true },
            layout = {
              box = 'horizontal',
              width = 0.8,
              height = 0.8,
              {
                box = 'vertical',
                border = 'rounded',
                title = '{source} {live} {flags}',
                title_pos = 'center',
                { win = 'input', height = 1, border = 'bottom' },
                { win = 'list', border = 'none' },
              },
              { win = 'preview', border = 'rounded', width = 0.7, title = '{preview}' },
            },
          },
    },
  },
  keys = {
    {
      "<leader>fe",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer (Snacks)",
    },
  },
}