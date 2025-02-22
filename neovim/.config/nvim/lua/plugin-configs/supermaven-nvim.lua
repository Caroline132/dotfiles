local env = vim.env.ENV
require("codecompanion").setup({
  keymaps = {
    accept_suggestion = "<C-f>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-j>",
  },
  enabled = function()
      print(env)
      if env == "work" then
          return false
      else
          return true
      end
  end,
})

