vim.cmd.colorscheme("onedark")

local M = {}

vim.cmd([[
      highlight SpellBad cterm=underline gui=underline guisp=red
      highlight SpellCap cterm=underline gui=underline guisp=blue
      highlight SpellLocal cterm=underline gui=underline guisp=cyan
      highlight SpellRare cterm=underline gui=underline guisp=magenta
      ]])


return M

