require("toggleterm").setup({
	shading_factor = "0",
	hide_numbers = false,
	direction = "float",
	start_in_insert = true,
	persist_mode = false,
	on_open = function(t)
		vim.opt_local.relativenumber = true
		vim.fn.timer_start(1, function()
			vim.cmd("startinsert!")
		end)
	end,
	size = function(term)
		if term.direction == "horizontal" then
			return vim.o.lines * 0.5
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.5
		end
	end,
})

local term = require("toggleterm.terminal").Terminal
vim.keymap.set({ "n", "t" }, "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle term" })
