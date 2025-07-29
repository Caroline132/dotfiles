local confui = require("ui")

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = "onedark",
    component_separators = "|",
    section_separators = "",
  },
  winbar = {
    lualine_c = { confui.winbar_symbol },
  },
}
