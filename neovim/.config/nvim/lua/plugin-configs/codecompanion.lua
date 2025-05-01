require("codecompanion").setup({
  display = {
    chat = {
      show_settings = false,
    },
  },
  adapters = {
    opts = {
      show_defaults = false,
    },
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = "claude-3.5-sonnet",
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "copilot",
    },
    inline = {
      adapter = "copilot",
    },
    agent = {
      adapter = "copilot",
    },
  },
})

  vim.keymap.set({"i", "n", "x"}, "<leader>ta", "<Cmd>CodeCompanionChat toggle<CR>", { desc = "Toggle CodeCompanionChat"})
  vim.keymap.set({"n", "x"}, "<localleader>a", "<Cmd>CodeCompanionActions <CR>", { desc = "Toggle CodeCompanionActions"})
