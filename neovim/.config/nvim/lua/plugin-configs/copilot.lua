vim.keymap.set('i', '<C-f>', '<Plug>(copilot-accept-word)')
local env = vim.env.ENV
require("copilot").setup({
  enabled = function()
      print(env)
      if env == "work" then
          return true
      else
          return false
      end
  end,
})
