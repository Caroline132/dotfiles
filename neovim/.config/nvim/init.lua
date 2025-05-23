-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = ","
-- vim.cmd([[ let maplocalleader = "\<bs>" ]])

require("options")
require("plugins")
require("keymaps")
require("json-yaml")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
