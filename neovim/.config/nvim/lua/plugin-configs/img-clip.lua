require("img-clip").setup({
	filetypes = {
		markdown = {
			url_encode_path = true,
			dir_path = ".attachments",
			template = "![$CURSOR](/$FILE_PATH)",
			use_absolute_path = false,
			relative_template_path = false,
		},
	},
})

vim.keymap.set({ "n" }, "<leader>p", "<cmd>PasteImage<cr>", { desc = "Paste image" })
