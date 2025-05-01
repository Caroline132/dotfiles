local M = {}

--- Creates a temporary split with the given command
---@param split_cmd string  command to use to create the split
---@return integer buffer number
local function create_temp_split(split_cmd)
  vim.cmd(split_cmd)

  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  return buf;
end

--- Create a temporary vertical split
---@return integer buffer number
function M.create_temp_vertical_split()
  return create_temp_split("vnew")
end

return M
