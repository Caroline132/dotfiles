require("window-picker").setup({
	hint = "floating-big-letter",
	-- when there is only one window available to pick from, use that window
	-- without prompting the user to select
	autoselect_one = true,

	-- whether you want to include the window you are currently on to window
	-- selection or not
	include_current_win = true,

	-- when you go to window selection mode, status bar will show one of
	-- following letters on them so you can use that letter to select the window
	selection_chars = "FJDKSLA;CMRUEIWOQP",

	-- if you want to manually filter out the windows, pass in a function that
	-- takes two parameters. you should return window ids that should be
	-- included in the selection
	-- EX:-
	-- function(window_ids, filters)
	--    -- filter the window_ids
	--    -- return only the ones you want to include
	--    return {1000, 1001}
	-- end
	filter_func = nil,

	-- following filters are only applied when you are using the default filter
	-- defined by this plugin. if you pass in a function to "filter_func"
	-- property, you are on your own
	filter_rules = {
		-- filter using buffer options
		bo = {
			-- if the file type is one of following, the window will be ignored
			filetype = { "notify", "neo-tree", "neo-tree-popup", "quickfix", "scrollview" },

			-- if the buffer type is one of following, the window will be ignored
			buftype = { "nofile" },
		},

		-- filter using window options
		wo = {},

		-- if the file path contains one of following names, the window
		-- will be ignored
		file_path_contains = {},

		-- if the file name contains one of following names, the window will be
		-- ignored
		file_name_contains = {},
	},

	-- if you have include_current_win == true, then current_win_hl_color will
	-- be highlighted using this background color
	current_win_hl_color = "#e35e4f",

	-- all the windows except the curren window will be highlighted using this
	-- color
	other_win_hl_color = "#44cc41",
})
local function switch_window()
	local window = require("window-picker").pick_window()
	vim.api.nvim_set_current_win(window)
end
local function close_window()
	local window = require("window-picker").pick_window()
	vim.api.nvim_win_close(window, false)
end
local function swap_window()
	local picked_window = require("window-picker").pick_window()
	local picked_buffer = vim.api.nvim_win_get_buf(picked_window)
	local current_buffer = vim.api.nvim_get_current_buf()
	local current_window = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(picked_window, current_buffer)
	vim.api.nvim_win_set_buf(current_window, picked_buffer)
end

vim.keymap.set("n", "<c-w>S", swap_window, { desc = "Swap window by id" })
vim.keymap.set("n", "<c-w>m", switch_window, { desc = "Move to window by id" })
vim.keymap.set("n", "<c-w>Q", close_window, { desc = "Close window by id" })
