-- See `:help telescope` and `:help telescope.setup()`
local action_state = require("telescope.actions.state")
local action_mt = require("telescope.actions.mt")
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")

local custom_actions = {}

custom_actions.yank_entry = function(prompt_bufnr)
	local entry = action_state.get_selected_entry()
	vim.fn.setreg("+", entry.value)
	actions.close(prompt_bufnr)
end

local pick_window = function(prompt_bufnr, direction)
	-- Use nvim-window-picker to choose the window by dynamically attaching a function
	local picker = action_state.get_current_picker(prompt_bufnr)
	picker.get_selection_window = function(pickr, _)
		local picked_window_id = require("window-picker").pick_window({
			autoselect_one = true,
			include_current_win = true,
		}) or vim.api.nvim_get_current_win()
		-- Unbind after using so next instance of the picker acts normally
		pickr.get_selection_window = nil
		return picked_window_id
	end

	action_set.select(prompt_bufnr, direction)
	vim.cmd("stopinsert")
end

local pick_vertical = function(prompt_bufnr)
	pick_window(prompt_bufnr, "vertical")
end
local pick_horizontal = function(prompt_bufnr)
	pick_window(prompt_bufnr, "horizontal")
end
local pick_default = function(prompt_bufnr)
	pick_window(prompt_bufnr, "default")
end

require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
		},
		file_ignore_patterns = { "node_modules/", ".git/", ".attachments/" },
		prompt_prefix = " ",
		selection_caret = "󰼛 ",
		entry_prefix = "  ",
		initial_mode = "insert",
		path_display = { "relative" },
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		layout_strategy = "vertical",
		layout_config = {
			horizontal = {
				mirror = false,
				width = 0.95,
				height = 0.95,
				preview_width = 0.5,
			},
			vertical = {
				mirror = false,
				width = 0.95,
				height = 0.95,
				prompt_position = "bottom",
			},
		},
		mappings = {
			i = {
				-- To disable a keymap, put [map] = false
				-- So, to not map "<C-n>", just put
				-- ["<c-x>"] = false,
				["<esc>"] = actions.close,
				["<F6>"] = actions.close,
				["<C-v>"] = pick_vertical,
				["<C-x>"] = pick_horizontal,
				["<C-s>"] = pick_default,
			},
		},
	},
	extensions = {
		advanced_git_search = {
			-- See Config
			diff_plugin = "diffview",
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

require("telescope").load_extension("advanced_git_search")

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
	-- Use the current buffer's path as the starting point for the git search
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir
	local cwd = vim.fn.getcwd()
	-- If the buffer is not associated with a file, return nil
	if current_file == "" then
		current_dir = cwd
	else
		-- Extract the directory from the current file's path
		current_dir = vim.fn.fnamemodify(current_file, ":h")
	end

	-- Find the Git root directory from the current file's path
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		print("Not a git repository. Searching on current working directory")
		return cwd
	end
	return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
	local git_root = find_git_root()
	if git_root then
		require("telescope.builtin").live_grep({
			search_dirs = { git_root },
		})
	end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

local function telescope_live_grep_open_files()
	require("telescope.builtin").live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end
vim.keymap.set("n", "<leader>s/", telescope_live_grep_open_files, { desc = "[S]earch [/] in Open Files" })
vim.keymap.set("n", "<leader>ss", require("telescope.builtin").builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "[S]earch [B]uffers" })
local dir = require("telescope.utils").buffer_dir()
vim.keymap.set("n", "<leader>sF", function()
	require("telescope.builtin").find_files({
		hidden = true,
		cwd = dir,
		no_ignore = true,
	})
end, { desc = "[S]earch [F]iles in dir" })
vim.keymap.set("n", "<leader>sf", function()
	require("telescope.builtin").find_files({
		hidden = true,
		no_ignore = true,
	})
end, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sG", function()
	require("telescope.builtin").live_grep({
		hidden = true,
		cwd = dir,
	})
end, { desc = "[S]earch by [G]rep in dir" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
-- vim.keymap.set("n", "<leader>sF", require("telescope.builtin").git_files, { desc = "[S]earch [G]it [F]iles" })

vim.api.nvim_create_user_command(
	"DiffCommitLine",
	"lua require('telescope').extensions.advanced_git_search.diff_commit_line()",
	{ range = true }
)

vim.api.nvim_set_keymap("v", "<leader>gl", ":DiffCommitLine<CR>", { noremap = true, desc = "Advanced line diff" })
vim.keymap.set(
	"n",
	"<leader>gb",
	require("telescope").extensions.advanced_git_search.diff_commit_file,
	{ desc = "Advanced buffer diff" }
)
vim.keymap.set(
	"n",
	"<leader>gi",
	require("telescope").extensions.advanced_git_search.search_log_content,
	{ desc = "Advanced Search inside commit contents" }
)
vim.keymap.set(
	"n",
	"<leader>gf",
	require("telescope").extensions.advanced_git_search.diff_branch_file,
	{ desc = "Advanced Branch file" }
)
vim.keymap.set("n", "<leader>gB", "<cmd>Telescope git_bcommits<cr>", { desc = "Buffer commits" })
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Commits" })
vim.keymap.set(
	"n",
	"<leader>gr",
	require("telescope").extensions.advanced_git_search.checkout_reflog,
	{ desc = "Advanced Reflog" }
)
