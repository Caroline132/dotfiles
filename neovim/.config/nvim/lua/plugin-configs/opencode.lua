require("opencode").setup({
	-- Uses snacks.nvim for picker (already in your config)
	preferred_picker = "snacks",
	-- Uses blink.cmp for completion (already in your config)
	preferred_completion = "blink",
	-- Default keymaps with <leader>o prefix
	default_global_keymaps = true,
	keymap_prefix = "<leader>o",
	ui = {
		position = "right",
		window_width = 0.40,
		display_model = true,
		display_context_size = true,
		display_cost = true,
		-- Don't persist state - always start fresh (no previous chat on toggle)
		persist_state = false,
		output = {
			-- render-markdown.nvim is already configured
			filetype = "opencode_output",
		},
	},
	context = {
		enabled = true,
		current_file = {
			enabled = true,
			show_full_path = true,
		},
		selection = {
			enabled = true,
		},
		diagnostics = {
			warning = true,
			error = true,
		},
	},
	keymap = {
		editor = {
			["<F11>"] = { "open_input_new_session" }, -- Always open with new session
		},
	},
})

-- Enable line numbers and relative line numbers in opencode windows
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "opencode_input", "opencode_output", "opencode" },
	callback = function()
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true
	end,
})

-- Also try by buffer name pattern
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname:match("opencode") or vim.bo.filetype:match("opencode") then
			vim.opt_local.number = true
			vim.opt_local.relativenumber = true
		end
	end,
})
