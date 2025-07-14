-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Make line numbers relative
vim.wo.relativenumber = true

-- Make indent 4 tabs
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Disable swapfile
vim.o.swapfile = false

-- Enable mouse mode
-- vim.o.mouse = "a"
vim.o.mouse = ""

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Split from below
vim.o.splitbelow = true

-- Split right
vim.o.splitright = true

-- Remove wrap
-- vim.o.wrap = true
vim.opt.textwidth = 0

-- Set clipboard to system's
vim.o.clipboard = "unnamedplus"

-- Keep cursor in middle
-- vim.opt.scrolloff = 999

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Required for bufferline
vim.opt.termguicolors = true

-- Disable arrow
vim.keymap.set({ "n", "x", "i" }, "<Left>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "i" }, "<Up>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "i" }, "<Right>", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "i" }, "<Down>", "<Nop>", { noremap = true, silent = true })

vim.opt.termguicolors = true

vim.g.editorconfig = true

-- Remove blinking from terminal cursor
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:blinkon0"

vim.g.disable_autoformat = true

-- Large file optimizations
vim.opt.maxmempattern = 2000000  -- Increase maximum amount of memory in Kb used for pattern matching
vim.opt.redrawtime = 10000       -- Time in milliseconds for redrawing the display
vim.opt.synmaxcol = 240          -- Maximum column in which to search for syntax items
vim.opt.lazyredraw = true        -- Don't redraw screen while executing macros

-- Disable features that might slow down large files
local function disable_features_for_large_files()
  local max_filesize = 100 * 1024 -- 100 KB in bytes
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
  
  if ok and stats and stats.size > max_filesize then
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.syntax = "off"
    vim.opt_local.relativenumber = false
    vim.opt_local.bufhidden = "unload"
  end
end

-- Create autocommand for large files
vim.api.nvim_create_autocmd({"BufReadPre"}, {
  callback = disable_features_for_large_files,
})
