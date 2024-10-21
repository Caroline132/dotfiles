local vault_dir = vim.env.OBSIDIAN_VAULT
require("obsidian").setup({
	workspaces = {
		{
			name = "default",
			path = vault_dir,
		},
	},
	ui = {
		enable = false,
	},
	new_notes_location = "current_dir",
})

local _add_checkbox = function(character, line_num)
	local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]

	local checkbox_pattern = "^%s*- %[.] "
	local checkbox = character or " "

	if not string.match(line, checkbox_pattern) then
		local unordered_list_pattern = "^(%s*)[-*+] (.*)"
		if string.match(line, unordered_list_pattern) then
			line = string.gsub(line, unordered_list_pattern, "%1- [ ] %2")
		else
			line = string.gsub(line, "^(%s*)", "%1- [ ] ")
		end
	end
	local capturing_checkbox_pattern = "^(%s*- %[).(%] )"
	line = string.gsub(line, capturing_checkbox_pattern, "%1" .. checkbox .. "%2")

	-- 0-indexed
	vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, { line })
end

local _remove_checkbox = function(line_num)
	local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
	local checkbox_pattern = "^%s*- %[.]. "
	local capturing_checkbox_pattern = "^(%s*-) %[.%] (.*)"
	line = string.gsub(line, capturing_checkbox_pattern, "%1 %2")
	line = string.gsub(line, checkbox_pattern, "")
	-- 0-indexed
	vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, { line })
end

local toggle_checkbox = function(character)
	-- Check if we are in visual line mode
	local mode = vim.api.nvim_get_mode().mode

	local toggle_or_remove = function(character, line_num)
		if character == nil then
			-- Remove checkbox
			_remove_checkbox(line_num)
		else
			-- Add checkbox
			_add_checkbox(character, line_num)
		end
	end

	if mode == "V" or mode == "v" then
		-- Get the range of selected lines
		vim.cmd([[execute "normal! \<ESC>"]])
		local vstart = vim.fn.getcharpos("'<")
		local vend = vim.fn.getcharpos("'>")

		local line_start = vstart[2]
		local line_end = vend[2]

		-- Iterate over each line in the range and apply the transformation
		for line_num = line_start, line_end do
			toggle_or_remove(character, line_num)
		end
	else
		-- Normal mode
		-- Allow line_num to be optional, defaulting to the current line if not provided (normal mode)
		local line_num = unpack(vim.api.nvim_win_get_cursor(0))
		toggle_or_remove(character, line_num)
	end
end
vim.keymap.set({ "n", "v" }, "<leader>ox", function()
	toggle_checkbox("x")
end, { desc = "Set checkbox", noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>oc", function()
	toggle_checkbox(" ")
end, { desc = "Clear checkbox", noremap = true })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" })
vim.keymap.set("x", "<leader>oe", ":ObsidianExtractNote<cr>", { desc = "Extract to note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Search in notes" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New note" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Open" })
vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", { desc = "Paste img" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Rename note" })
vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick switch" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = "Today" })
vim.keymap.set("n", "<leader>oT", "<cmd>ObsidianTemplate<cr>", { desc = "Template" })
vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Yesterday" })
