local lint = require("lint")

lint.linters_by_ft = {
	dockerfile = { "hadolint" },
	dotenv = { "dotenv" },
	go = { "codespell", "golangci-lint", "revive" },
	javascript = { "eslint_d" },
	markdown = { "markdownlint" },
	yaml = { "yamllint" },
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