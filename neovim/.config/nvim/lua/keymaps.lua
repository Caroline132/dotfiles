-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })

vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Remove highlighted search by pressing esc
vim.api.nvim_set_keymap(
	"n",
	"<esc>",
	"<cmd>noh<cr><esc>",
	{ noremap = true, silent = true, desc = "Remove highlight or escape" }
)

-- Go to normal mode from terminal
vim.api.nvim_set_keymap("t", "<c-x>", [[<C-\><C-n><esc><cr>]], { noremap = true, silent = true, desc = "Normal mode" })

vim.keymap.set("i", "jk", "<esc>", { desc = "escape" })

-- Diffs between two selected buffers
local pick_buffer = function(callback)
	require("telescope.builtin").buffers({
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				local selection = require("telescope.actions.state").get_selected_entry()
				local bufnr = selection.bufnr
				-- Close the picker and call the callback with the selected buffer
				require("telescope.actions").close(prompt_bufnr)
				callback(bufnr)
			end)
			return true
		end,
	})
end

--- Get a list of all listed buffer names
---@return string[]
local function get_listed_buffers()
	local buf_names = {}
	for _, buf in ipairs(vim.fn.getbufinfo()) do
		if buf.listed == 1 and buf.name ~= "" then  -- Only include buffers with names
			buf_names[#buf_names + 1] = buf.name
		end
	end
	return buf_names
end

vim.keymap.set("n", "<localleader>db", function()
	local buf_names = get_listed_buffers()

	if 2 == 2 then
		-- Open the first buffer in a new tab
		vim.cmd("tabnew " .. vim.fn.fnameescape(buf_names[1]))
		-- Open the second buffer in a vertical diff split
		vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(buf_names[2]))
		vim.cmd.normal({ args = { "gg" }, bang = true })
	else
		local first_bufnumber, second_bufnumber

		-- Pick the first buffer
		pick_buffer(function(bufnr)
			first_bufnumber = bufnr
			-- After picking the first buffer, immediately ask for the second buffer
			if first_bufnumber then
				pick_buffer(function(bufnr)
					second_bufnumber = bufnr
					-- Proceed to diff if both buffers are selected
					if first_bufnumber and second_bufnumber then
						local first_buf = vim.fn.getbufinfo(first_bufnumber)[1]
						local second_buf = vim.fn.getbufinfo(second_bufnumber)[1]

						if first_buf and second_buf then
							vim.cmd("tabnew " .. vim.fn.fnameescape(first_buf.name))
							vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(second_buf.name))
							vim.cmd.normal({ args = { "gg" }, bang = true })
						end
					end
				end)
			end
		end)
	end
end, { desc = "Diff between open buffers" })

-- Diffs between current windows
local pick_window = function()
	-- Use nvim-window-picker to choose the window
	return require("window-picker").pick_window({
		hint = "floating-big-letter",
	})
end

--- Get list of active buffers from current list of windows
---@param windows number[]
---@return number[]
local function get_shown_buffers(windows)
	local buf_numbers = {}
	for _, win in ipairs(windows) do
		local buf = vim.api.nvim_win_get_buf(win)
		local bufinfo = vim.fn.getbufinfo(buf)[1]
		if bufinfo and bufinfo.hidden == 0 and bufinfo.listed == 1 then
			buf_numbers[#buf_numbers + 1] = buf
		end
	end
	return buf_numbers
end


vim.keymap.set("n", "<localleader>dd", function()
	local windows = vim.api.nvim_list_wins()
	local buf_numbers = get_shown_buffers(windows)

	if #buf_numbers == 2 then
		-- If there are exactly 2 visible buffers, diff them automatically
		vim.cmd("tabnew " .. vim.fn.fnameescape(vim.fn.getbufinfo(buf_numbers[1])[1].name))
		vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(vim.fn.getbufinfo(buf_numbers[2])[1].name))
		vim.cmd.normal({ args = { "gg" }, bang = true })
	else
		-- Otherwise, ask the user to pick two windows
		local first_win = pick_window()
		if not first_win then return end

		local second_win = pick_window()
		if not second_win then return end

		local first_bufnumber = vim.api.nvim_win_get_buf(first_win)
		local second_bufnumber = vim.api.nvim_win_get_buf(second_win)

		local first_buf = vim.fn.getbufinfo(first_bufnumber)[1]
		local second_buf = vim.fn.getbufinfo(second_bufnumber)[1]

		if first_buf and second_buf then
			vim.cmd("tabnew " .. vim.fn.fnameescape(first_buf.name))
			vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(second_buf.name))
			vim.cmd.normal({ args = { "gg" }, bang = true })
		end
	end
end, { desc = "Diff between window files" })

vim.keymap.set("x", "<localleader>dD", function()
	vim.cmd('noau normal! "vy')
	local filetype = vim.bo.filetype
	vim.cmd.tabnew()
	vim.cmd('noau normal! "0P')
	vim.bo.filetype = filetype
	vim.bo.buftype = "nowrite"
	vim.cmd.diffthis()
	vim.cmd.vsplit()
	vim.cmd.ene()
	vim.cmd('noau normal! "vP')
	vim.bo.filetype = filetype
	vim.bo.buftype = "nowrite"
	vim.cmd.diffthis()
end, { desc = "Diff selection with clipboard" })

vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Shift selection down" })
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Shift selection up" })
vim.api.nvim_set_keymap("x", "<", "<gv", { noremap = true, silent = true, desc = "Indent and keep selection" })
vim.api.nvim_set_keymap("x", ">", ">gv", { noremap = true, silent = true, desc = "Indent and keep selection" })
vim.keymap.set("n", "<leader>ts", "<Cmd>setlocal spell! spell?<CR>", { desc = "Toggle 'spell'" })

local toggle_diagnostic = function()
	local buf_id = vim.api.nvim_get_current_buf()

	if vim.diagnostic.is_enabled({ bufnr = buf_id }) then
		vim.diagnostic.enable(false, { bufnr = buf_id })
	else
		vim.diagnostic.enable(true, { bufnr = buf_id })
	end
end
vim.keymap.set("n", "td", function()
	print(toggle_diagnostic())
end, { desc = "Toggle diagnostic" })

vim.keymap.set("n", "]t", function()
	vim.cmd.tabnext()
end, { desc = "Next tab" })
vim.keymap.set("n", "[t", function()
	vim.cmd.tabprevious()
end, { desc = "Previous tab" })
vim.keymap.set("n", "<leader>x", "<cmd>tabclose<CR>", { desc = "Close tab" })
