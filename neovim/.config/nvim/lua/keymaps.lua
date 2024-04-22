-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })

vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Go to normal mode from terminal
vim.api.nvim_set_keymap("t", "<c-x>", [[<C-\><C-n><esc><cr>]], { noremap = true, silent = true, desc = "Normal mode" })

vim.keymap.set("i", "jk", "<esc>", { desc = "escape" })
vim.keymap.set("v", "jk", "<esc>", { desc = "escape" })

-- Diff
require("which-key").register({
	["<localleader>d"] = { name = "[D]iff", _ = "which_key_ignore" },
})

vim.keymap.set("n", "<localleader>dd", function()
	local split_filenames = {}
	for _, buf in ipairs(vim.fn.getbufinfo()) do
		if buf.hidden == 0 and buf.listed == 1 then
			table.insert(split_filenames, buf.name)
		end
	end
	if #split_filenames == 2 then
		vim.cmd.tabnew(split_filenames[1])
		vim.cmd("vertical diffsplit " .. split_filenames[2])
		vim.cmd.normal({ args = { "gg" }, bang = true })
	else
		vim.notify("Can't diff with more than 2 files open")
	end
end, { desc = "Diff between open files" })

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
