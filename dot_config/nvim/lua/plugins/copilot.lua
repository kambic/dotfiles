return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-f>", -- Accept suggestion with Ctrl + f
          accept_word = false,
          accept_line = false,
          next = "<M-]>",  -- Alt + ]
          prev = "<M-[>",  -- Alt + [
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
    },
  },
}