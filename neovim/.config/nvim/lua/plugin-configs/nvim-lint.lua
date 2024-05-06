local lint = require("lint")

lint.linters_by_ft = {
	dockerfile = { "hadolint" },
	go = { "codespell", "golangcilint" },
	javascript = { "eslint_d" },
	yaml = { "yamllint" },
	terraform = { "tflint" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})

vim.keymap.set("n", "<leader>l", function()
	lint.try_lint()
end, { desc = "Trigger linting for current file" })

lint.linters.yamllint.args = {
	'-d "{extends: default, rules: line-length: disable document-start: disable}"',
}
