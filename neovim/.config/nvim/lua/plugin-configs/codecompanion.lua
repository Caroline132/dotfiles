require("codecompanion").setup({
  extensions = {
    history = {
      enabled = true,
    },
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_vars = true,
        make_slash_commands = true,
        show_result_in_chat = true,
        log_level = "DEBUG",
      },
    },
  },
  display = {
    chat = {
      show_settings = false,
    },
  },
  -- adapters = {
  --   opts = {
  --     show_defaults = false,
  --   },
  --   copilot = function()
  --     return require("codecompanion.adapters").extend("copilot", {
  --       schema = {
  --         model = {
  --           -- default = "claude-3.5-sonnet",
  --           -- default = "claude-3.7-sonnet",
  --           default = "claude-sonnet-4",
  --           -- default = "gpt-4.1",
  --           -- default = "gemini-2.5-pro",
  --         },
  --       },
  --     })
  --   end,
  -- },
  strategies = {
    chat = {
      adapter = "copilot",
      default = "claude-sonnet-4.5",
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
vim.keymap.set({"n", "x"}, "<localleader>aa", "<Cmd>CodeCompanionActions <CR>", { desc = "Toggle CodeCompanionActions"})
vim.keymap.set({"n", "x"}, "<localleader>ah", "<Cmd>CodeCompanionHistory <CR>", { desc = "Toggle CodeCompanionHistory"})
