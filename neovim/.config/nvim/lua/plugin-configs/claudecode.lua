-- claudecode.nvim configuration
-- https://github.com/coder/claudecode.nvim

-- Fix upstream port probing: libuv's tcp:bind() succeeds even when the port is
-- in use (EADDRINUSE is only reported by listen()), so the plugin's check never
-- detects busy ports. Probe with bind + listen instead, and skip ports reserved
-- by other tools (mcphub uses 37373).
local reserved_ports = { [37373] = true }
local tcp = require("claudecode.server.tcp")
tcp.find_available_port = function(min_port, max_port)
	math.randomseed(vim.uv.hrtime() + vim.fn.getpid())
	local tried = {}
	for _ = 1, 200 do
		local port = math.random(min_port, max_port)
		if not tried[port] and not reserved_ports[port] then
			tried[port] = true
			local probe = vim.uv.new_tcp()
			if probe then
				local ok = probe:bind("127.0.0.1", port) and probe:listen(1, function() end)
				probe:close()
				if ok then
					return port
				end
			end
		end
	end
	return nil
end

require("claudecode").setup({
	-- Server Configuration
	port_range = { min = 10000, max = 65535 },
	auto_start = true,
	log_level = "info", -- "trace", "debug", "info", "warn", "error"

	-- Send/Focus Behavior
	-- When true, successful sends will focus the Claude terminal if already connected
	focus_after_send = false,

	-- Selection Tracking
	track_selection = true,
	visual_demotion_delay_ms = 50,

	-- Terminal Configuration
	terminal = {
		split_side = "right", -- "left" or "right"
		split_width_percentage = 0.30,
		provider = "auto", -- "auto", "snacks", "native", "external", "none"
		auto_close = true,
		fix_streamed_paste = "auto",

		-- Snacks-specific window options (if using snacks provider)
		snacks_win_opts = {},
	},

	-- Diff Integration
	diff_opts = {
		layout = "vertical", -- "vertical" or "horizontal"
		open_in_new_tab = false,
		keep_terminal_focus = false,
		hide_terminal_in_new_tab = false,
	},
})

-- Keymaps
local keymap = vim.keymap.set

-- F12 for quick toggle (works in both normal and terminal mode)
keymap("n", "<F12>", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
keymap("t", "<F12>", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })

-- AI/Claude Code leader mappings
keymap("n", "<leader>a", "", { desc = "AI/Claude Code" })
keymap("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
keymap("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
keymap("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
keymap("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
keymap("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
keymap("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })

-- Visual mode: send selection to Claude
keymap("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })

-- File tree integration via autocmd (for NvimTree, neo-tree, oil, minifiles, netrw)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
	callback = function()
		vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", { buffer = true, desc = "Add file to Claude" })
	end,
})

-- Diff management
keymap("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
keymap("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })
keymap("n", "<leader>aD", "<cmd>ClaudeCodeCloseAllDiffs<cr>", { desc = "Close all diffs" })
