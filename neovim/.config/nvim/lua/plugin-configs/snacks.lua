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
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
            ["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
            ["<c-v>"] = { { "pick_win_updated", "edit_vsplit" }, mode = { "i", "n" } },
            ["<c-s>"] = { { "pick_win_updated", "edit_split" }, mode = { "i", "n" } },
            ["<c-e>"] = { { "pick_win_updated", "edit" }, mode = { "i", "n" } },
            ["<c-t>"] = { "edit_tab", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<c-u>"] = { "list_scroll_down", mode = { "i", "n" } },
            ["<c-d>"] = { "list_scroll_up", mode = { "i", "n" } },
          },
        },
      },
    },
  },
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
})

vim.keymap.set("n", "<leader>sf", function()
  Snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<localleader>th", Snacks.notifier.show_history, { desc = "Notifications history" })
