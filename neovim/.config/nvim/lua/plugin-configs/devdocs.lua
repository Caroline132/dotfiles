require("devdocs").setup({
  ensure_installed = {
    "go",
    "html",
    -- "dom",
    "kubectl",
    -- "css",
    -- "javascript",
    "kubernetes",
    "terraform",
  },
})

vim.keymap.set("n", "<localleader>hg", "<cmd>DevDocs get<CR>", { desc = "Get Devdocs" })
