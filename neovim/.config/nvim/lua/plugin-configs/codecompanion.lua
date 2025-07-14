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
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          show_result_in_chat = true,  -- Show mcp tool results in chat
          make_vars = true,            -- Convert resources to #variables
          make_slash_commands = true,  -- Add prompts as /slash commands
        }
      }
    } },
})

vim.keymap.set({"i", "n", "x"}, "<leader>ta", "<Cmd>CodeCompanionChat toggle<CR>", { desc = "Toggle CodeCompanionChat"})
vim.keymap.set({"n", "x"}, "<localleader>a", "<Cmd>CodeCompanionActions <CR>", { desc = "Toggle CodeCompanionActions"})
