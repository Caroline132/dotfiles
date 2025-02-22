require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "copilot",
    },
    inline = {
      adapter = "copilot",
    },
  },
})

  vim.keymap.set({"i", "n", "x"}, "<leader>ta", "<Cmd>CodeCompanionChat toggle<CR>", { desc = "Toggle CodeCompanionChat"})
  vim.keymap.set({"n", "x"}, "<localleader>a", "<Cmd>CodeCompanionActions <CR>", { desc = "Toggle CodeCompanionActions"})
