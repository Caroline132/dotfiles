local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "yamlfmt" },
		markdown = { "prettier" },
		graphql = { "prettier" },
		-- lua = { "stylua" },
		python = { "isort", "black" },
		go = { "goimports", "gofmt" },
		sh = { "shfmt" },
		zsh = { "shfmt" },
		-- Use the "*" filetype to run formatters on all filetypes.
		-- ["*"] = { "codespell" },
		-- Use the "_" filetype to run formatters on filetypes that don't
		-- have other formatters configured.
		["_"] = { "trim_whitespace" },
	},
	format_after_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { async = true, lsp_format = "fallback" }
	end,
})
conform.formatters.shfmt = {
	prepend_args = { "-i", "2" },
	-- The base args are { "-filename", "$FILENAME" } so the final args will be
	-- { "-i", "2", "-filename", "$FILENAME" }
}

vim.api.nvim_create_user_command("FormatToggle", function(args)
	if vim.g.disable_autoformat == true then
		-- FormatDisable! will disable formatting just for this buffer
		vim.g.disable_autoformat = false
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Toggle autoformat-on-save",
})
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.api.nvim_set_keymap(
	"n",
	"<Leader>tf",
	":FormatToggle<CR>",
	{ noremap = true, silent = true, desc = "Toggle format" }
)

vim.api.nvim_set_keymap(
	"n",
	"<Leader>f",
	":Format<CR>",
	{ noremap = true, silent = true, desc = "Format current buffer" }
)
