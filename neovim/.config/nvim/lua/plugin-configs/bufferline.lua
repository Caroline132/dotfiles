require("bufferline").setup({
	options = {
		numbers = "ordinal",
	},
})

vim.keymap.set({ "n", "x" }, "H", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
vim.keymap.set({ "n", "x" }, "L", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set({ "n", "x" }, "<leader>1", "<cmd>lua require('bufferline').go_to(1, true)<cr>", { desc = "Buf 1" })
vim.keymap.set({ "n", "x" }, "<leader>2", "<cmd>lua require('bufferline').go_to(2, true)<cr>", { desc = "Buf 2" })
vim.keymap.set({ "n", "x" }, "<leader>3", "<cmd>lua require('bufferline').go_to(3, true)<cr>", { desc = "Buf 3" })
vim.keymap.set({ "n", "x" }, "<leader>4", "<cmd>lua require('bufferline').go_to(4, true)<cr>", { desc = "Buf 4" })
vim.keymap.set({ "n", "x" }, "<leader>5", "<cmd>lua require('bufferline').go_to(5, true)<cr>", { desc = "Buf 5" })
vim.keymap.set({ "n", "x" }, "<leader>6", "<cmd>lua require('bufferline').go_to(6, true)<cr>", { desc = "Buf 6" })
vim.keymap.set({ "n", "x" }, "<leader>7", "<cmd>lua require('bufferline').go_to(7, true)<cr>", { desc = "Buf 7" })
vim.keymap.set({ "n", "x" }, "<leader>8", "<cmd>lua require('bufferline').go_to(8, true)<cr>", { desc = "Buf 8" })
vim.keymap.set({ "n", "x" }, "<leader>9", "<cmd>lua require('bufferline').go_to(9, true)<cr>", { desc = "Buf 9" })
vim.keymap.set({ "n", "x" }, "<leader>0", "<cmd>lua require('bufferline').go_to(10, true)<cr>", { desc = "Buf 10" })
vim.keymap.set({ "n", "x" }, "<leader>bd", "<cmd>bn | bd#<cr>", { desc = "Delete-buffer" })
vim.keymap.set(
	{ "n", "x" },
	"<leader>b$",
	"<cmd>lua require('bufferline').go_to(-1, true)<cr>",
	{ desc = "Last buffer" }
)
vim.keymap.set({ "n", "x" }, "<leader>bk", "<cmd>BufferLineMovePrev<cr>", { desc = "Move backwards" })
vim.keymap.set({ "n", "x" }, "<leader>bj", "<cmd>BufferLineMoveNext<cr>", { desc = "Move forwards" })
vim.keymap.set({ "n", "x" }, "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", { desc = "Delete buffers to the left" })
vim.keymap.set({ "n", "x" }, "<leader>bl", "<cmd>BufferLineCloseRight<cr>", { desc = "Delete buffers to the right" })
vim.keymap.set({ "n", "x" }, "<leader>bD", "<cmd>BufferLineCloseOthers<cr>", { desc = "Delete all other buffers" })
vim.keymap.set({ "n", "x" }, "<leader>bs", "<cmd>BufferLinePick<cr>", { desc = "Magic buffer select" })
