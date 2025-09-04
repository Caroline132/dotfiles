local Snacks = require("snacks")
Snacks.setup({
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  indent = { enabled = false },
  input = { enabled = false },
  notifier = {
    enabled = false,
    timeout = 3000,
  },
  picker = {
    enabled = true,
    layout = "dropdown",
    matcher = {
      frecency = true,
    },
    layouts = {
      dropdown = {
        layout = {
          backdrop = false,
          row = 1,
          width = 0.9,
          min_width = 80,
          height = 0.9,
          border = "none",
          box = "vertical",
          { win = "preview", title = "{preview}", height = 0.6, border = "rounded" },
          {
            box = "vertical",
            border = "rounded",
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
          },
        },
      },
    },
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<c-n>"] = { "list_scroll_down", mode = { "i", "n" } },
          ["<c-p>"] = { "list_scroll_up", mode = { "i", "n" } },
        },
      },
    },
  },
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  words = { enabled = false },
})

-- Picker
vim.keymap.set("n", "<leader>sf", function()
  Snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Files" })
vim.keymap.set("n", "<leader>?", function() Snacks.picker.recent() end, { desc = "Find recently opened files" })
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.buffers() end, { desc = "Search buffers" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep_buffers() end, { desc = "Grep in current buffers" })
vim.keymap.set("n", "<leader>sp", function()
  Snacks.picker.pickers()
end, { desc = "Snacks Pickers" })
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help" })
vim.keymap.set("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep word" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
local function dir()
  local bufname = vim.api.nvim_buf_get_name(0)
  return bufname ~= "" and vim.fn.fnamemodify(bufname, ":h") or vim.loop.cwd()
end
vim.keymap.set("n", "<leader>sG", function()
  Snacks.picker.grep({ hidden = true, ignored = true, cwd = dir() })
end, { desc = "Grep in dir" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sr", function() Snacks.picker.resume() end, { desc = "Resume" })
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, {desc = "Marks"})
vim.keymap.set("n", "<leader>sM", function() Snacks.picker.man() end, {desc = "Man Pages"})
vim.keymap.set("n", "<leader>sp", function() Snacks.picker.lazy() end, {desc = "Search for Plugin Spec"})
vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, {desc = "Quickfix List"})
vim.keymap.set("n", "<leader>sgB", Snacks.picker.git_log_file, { desc = "Buffer commits" })
vim.keymap.set("n", "<leader>sgc", Snacks.picker.git_log, { desc = "Commits" })
vim.keymap.set("n", "<leader>sgd", Snacks.picker.git_diff, { desc = "Diff" })
vim.keymap.set("n", "<leader>sgs", Snacks.picker.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>n", function() Snacks.picker.notifications() end, {desc = "Notification History" })

-- Notifier
vim.keymap.set("n", "<localleader>th", Snacks.notifier.show_history, { desc = "Notifications history" })
