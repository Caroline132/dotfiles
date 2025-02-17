local function read_file(path)
  local file = io.open(path, "r")
  if not file then return nil end
  local content = file:read("*a")
  file:close()
  return content:gsub("%s+", "") -- Trim any whitespace/newlines
end

require("codecompanion").setup({
  adapters = {
    anthropic = function()
      local api_key = read_file("/home/caro/tokens/token.txt") -- Adjust the path
      return require("codecompanion.adapters").extend("copilot", {
        env = {
          api_key = api_key,
        },
      })
    end,
  },
})

