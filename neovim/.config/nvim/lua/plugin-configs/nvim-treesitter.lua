-- See `:help nvim-treesitter`

local ensure_installed = {
	"c",
	"cpp",
	"go",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"rust",
	"tsx",
	"javascript",
	"typescript",
	"vimdoc",
	"vim",
	"bash",
	"yaml",
	"jsonnet",
	"nu",
}

-- Install parsers after lazy is done
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyDone",
	once = true,
	callback = function()
		require("nvim-treesitter").install(ensure_installed)
	end,
})

-- Filetypes to ignore for treesitter highlighting
local ignored_filetypes = {
	"checkhealth",
	"lazy",
	"mason",
	"snacks_dashboard",
	"snacks_notif",
	"snacks_win",
	"snacks_input",
	"snacks_picker_input",
}

-- Enable treesitter highlighting per filetype with pcall to catch errors
vim.api.nvim_create_autocmd("FileType", {
	callback = function(event)
		if vim.tbl_contains(ignored_filetypes, event.match) then
			return
		end
		pcall(vim.treesitter.start) -- errors for filetypes with no parser
	end,
	desc = "Enable treesitter highlighting",
})
