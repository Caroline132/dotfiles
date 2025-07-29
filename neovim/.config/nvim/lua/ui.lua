local M = {}

M.winbar_symbol = function()
    ---@diagnostic disable-next-line
    if not vim.lsp.buf_is_attached(0) then
        return ''
    end

    local navic = require 'nvim-navic'

    if navic.is_available() then
        return navic.get_location()
    end

    return ''
end

return M
