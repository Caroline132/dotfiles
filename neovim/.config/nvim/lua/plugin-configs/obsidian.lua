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

local toggle_strikethrough = function()
    -- Get current mode
    local mode = vim.api.nvim_get_mode().mode

    local add_strikethrough = function(line_num)
        local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
        -- Check if line is already struck through
        if string.match(line, "^~~.*~~$") then
            -- Remove strikethrough
            line = string.gsub(line, "^~~(.*)~~$", "%1")
        else
            -- Add strikethrough
            line = "~~" .. line .. "~~"
        end
        vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, { line })
    end

    if mode == "V" or mode == "v" then
        -- Visual mode: handle multiple lines
        vim.cmd([[execute "normal! \<ESC>"]])
        local vstart = vim.fn.getcharpos("'<")
        local vend = vim.fn.getcharpos("'>")

        local line_start = vstart[2]
        local line_end = vend[2]

        for line_num = line_start, line_end do
            add_strikethrough(line_num)
        end
    else
        -- Normal mode: handle current line
        local line_num = unpack(vim.api.nvim_win_get_cursor(0))
        add_strikethrough(line_num)
    end
end

local convert_to_list = function(list_type)
    local mode = vim.api.nvim_get_mode().mode

    local add_list_marker = function(line_num, list_type)
        local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
        -- Skip empty lines
        if line:match("^%s*$") then
            return
        end
        -- Remove existing list markers if any
        line = line:gsub("^%s*[-*+]%s*", "")
        line = line:gsub("^%s*-%s*%[.%]%s*", "")
        -- Preserve existing indentation
        local indent = line:match("^(%s*)")
        -- Add new list marker
        if list_type == "bullet" then
            line = indent .. "- " .. line:gsub("^%s*", "")
        elseif list_type == "checkbox" then
            line = indent .. "- [ ] " .. line:gsub("^%s*", "")
        end
        vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, { line })
    end

    if mode == "V" or mode == "v" then
        -- Visual mode: handle multiple lines
        vim.cmd([[execute "normal! \<ESC>"]])
        local vstart = vim.fn.getcharpos("'<")
        local vend = vim.fn.getcharpos("'>")

        local line_start = vstart[2]
        local line_end = vend[2]

        for line_num = line_start, line_end do
            add_list_marker(line_num, list_type)
        end
    else
        -- Normal mode: handle current line
        local line_num = unpack(vim.api.nvim_win_get_cursor(0))
        add_list_marker(line_num, list_type)
    end
end

local numbered_to_bullet = function(line_num)
    local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
    -- Replace leading numbered list (e.g., "  1. ") with bullet ("  - ")
    line = line:gsub("^(%s*)%d+%.%s+", "%1- ")
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, { line })
end


-- Add these keymaps with your other keymaps
vim.keymap.set({ "n", "v" }, "<leader>ol", function()
    convert_to_list("bullet")
end, { desc = "Convert to bullet list", noremap = true })

vim.keymap.set({ "n", "v" }, "<leader>ok", function()
    convert_to_list("checkbox")
end, { desc = "Convert to checklist", noremap = true })

-- Add the keymap (put this with your other keymaps)
vim.keymap.set({ "n", "v" }, "<leader>o-", function()
    toggle_strikethrough()
end, { desc = "Toggle strikethrough", noremap = true })
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
vim.keymap.set({ "n", "v" }, "<leader>o.", function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "V" or mode == "v" then
        vim.cmd([[execute "normal! \<ESC>"]])
        local vstart = vim.fn.getcharpos("'<")
        local vend = vim.fn.getcharpos("'>")
        local line_start = vstart[2]
        local line_end = vend[2]
        for line_num = line_start, line_end do
            numbered_to_bullet(line_num)
        end
    else
        local line_num = unpack(vim.api.nvim_win_get_cursor(0))
        numbered_to_bullet(line_num)
    end
end, { desc = "Convert numbered list to bullet", noremap = true })
