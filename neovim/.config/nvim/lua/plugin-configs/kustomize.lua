require("kustomize").setup({
  enable_key_mappings = false,
  enable_lua_snip = true,
})

vim.api.nvim_set_keymap("n", "<leader>kb", "<cmd>KustomizeBuild<cr>", { desc = "Build Kustomize" })
vim.api.nvim_set_keymap("n", "<leader>kk", "<cmd>KustomizeListKinds<cr>", { desc = "List Kubernetes Kinds" })
vim.api.nvim_set_keymap("n", "<leader>kl", "<cmd>KustomizeListResources<cr>", { desc = "List Kubernetes Resources" })
vim.api.nvim_set_keymap("n", "<leader>kp", "<cmd>KustomizePrintResources<cr>", { desc = "Print Kubernetes Resources" })
vim.api.nvim_set_keymap("n", "<leader>kv", "<cmd>KustomizeValidate<cr>", { desc = "Validate Kustomize Resources" })
vim.api.nvim_set_keymap("n", "<leader>kd", "<cmd>KustomizeDeprecations<cr>", { desc = "List Deprecations" })
-- vim.keymap.set("n", "<leader>kb", "<cmd>lua require('kustomize').build()<cr>", { noremap = true, desc = "kustomize build" })
-- vim.keymap.set("n", "<leader>kk", "<cmd>lua require('kustomize').kinds()<cr>", { noremap = true, desc = "kustomize kinds" })
-- vim.keymap.set("n", "<leader>kl", "<cmd>lua require('kustomize').list_resources()<cr>", { noremap = true, desc = "kustomize list resources" })
-- vim.keymap.set("n", "<leader>kp", "<cmd>lua require('kustomize').print_resources()<cr>", { noremap = true, desc = "kustomize print resources" })
-- vim.keymap.set("n", "<leader>kv", "<cmd>lua require('kustomize').validate()<cr>", { noremap = true, desc = "kustomize validate" })
-- vim.keymap.set("n", "<leader>kd", "<cmd>lua require('kustomize').deprecations()<cr>", { noremap = true, desc = "kustomize deprecations" })
