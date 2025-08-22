-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
	-- NOTE: First, some plugins that don't require any configuration

	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	"airblade/vim-rooter",
	{
		"tyru/capture.vim",
		cmd = "Capture",
	},
	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
		config = function()
			require("plugin-configs.lsp")
		end,
	},
	{
		"Saghen/blink.cmp",
		config = function()
			require("plugin-configs.blink")
		end,
		dependencies = {
			"L3MON4D3/LuaSnip",
		},
		version = "v0.*",
	},


	-- Useful plugin to show you pending keybinds.
	{
		"folke/which-key.nvim",
		opts = {},
		config = function()
			require("plugin-configs.which-key")
		end,
	},
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		config = function()
			require("plugin-configs.gitsigns")
		end,
	},

	{
		-- Theme inspired by Atom
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("onedark")
		end,
	},

	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				theme = "onedark",
				component_separators = "|",
				section_separators = "",
			},
		},
	},

	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = "ibl",
		opts = {},
	},

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				-- NOTE: If you are having trouble with this installation,
				--       refer to the README for telescope-fzf-native for more instructions.
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "molecule-man/telescope-menufacture" },
			{ "aaronhallaert/ts-advanced-git-search.nvim" },
		},
		config = function()
			require("plugin-configs.telescope-config")
		end,
	},
	{
		"sindrets/diffview.nvim",
		config = function()
			require("plugin-configs.diffview")
		end,
	},

	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("plugin-configs.nvim-treesitter")
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("plugin-configs.neo-tree")
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		"akinsho/bufferline.nvim",
		lazy = false,
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("plugin-configs.bufferline")
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
		config = function()
			require("plugin-configs.markdown-preview")
		end,
	},
	-- {
	-- 	"OXY2DEV/markview.nvim",
	-- 	dependencies = {
	-- 		"nvim-tree/nvim-web-devicons", -- Used by the code bloxks
	-- 	},
	--
	-- 	config = function()
	-- 		require("markview").setup()
	-- 	end,
	-- },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
		  require("plugin-configs.render-markdown")
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
		lazy = false,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("plugin-configs.autopairs")
		end,
	},
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugin-configs.conform")
		end,
	},
	{
		"mfussenegger/nvim-lint",
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		config = function()
			require("plugin-configs.nvim-lint")
		end,
	},
	{
		"HakonHarnes/img-clip.nvim",
		config = function()
			require("plugin-configs.img-clip")
		end,
	},
	{
		-- amongst your other plugins
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("plugin-configs.toggleterm")
		end,
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		config = function()
			require("barbecue").setup()
		end,
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
	},
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		config = function()
			require("plugin-configs.todo-comments")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugin-configs.indent-blankline")
		end,
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("plugin-configs.mini-ai")
			-- require("plugin-configs.mini-clue")
			-- require("plugin-configs.mini-statusline")
			-- require("plugin-configs.mini-surround")
			require("plugin-configs.mini-indentscope")
		end,
	},
	{
		"gbprod/substitute.nvim",
		config = function()
			require("plugin-configs.substitute")
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("plugin-configs.supermaven-nvim")
		end,
		enabled = vim.fn.getenv("WSL_INTEROP") == vim.NIL,
	},
	{
		"github/copilot.vim",
		config = function()
			require("plugin-configs.copilot")
		end,
		enabled = vim.fn.getenv("WSL_INTEROP") ~= vim.NIL,
	},

	-- Themes
	{
		"folke/tokyonight.nvim",
		event = "User LoadColorSchemes",
		opts = {
			style = "storm",
			dim_inactive = false,
		},
	},
	{
		"NTBBloodbath/sweetie.nvim",
		event = "User LoadColorSchemes",
	},
	{
		"catppuccin/nvim",
		event = "User LoadColorSchemes",
		name = "catppuccin",
		config = function()
			vim.g.catppuccin_flavour = "latte"
		end,
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		config = function()
			require("plugin-configs.obsidian")
		end,
	},
	{
		"LudoPinelli/comment-box.nvim",
		config = function()
			require("plugin-configs.comment-box")
		end,
	},
	{
		"s1n7ax/nvim-window-picker",
		config = function()
			require("plugin-configs.nvim-window-picker")
		end,
	},
	{
		"towolf/vim-helm",
		ft = { "helm" },
	},
	{
		"Allaman/kustomize.nvim",
		config = function()
			require("plugin-configs.kustomize")
		end,
	},
	{
		"quentingruber/pomodoro.nvim",
		config = function()
			require("plugin-configs.pomodoro")
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"ravitemer/codecompanion-history.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("plugin-configs.codecompanion")
		end,
		enabled = vim.fn.getenv("WSL_INTEROP") ~= vim.NIL,
	},
	{
		"maskudo/devdocs.nvim",
		config = function()
			require("plugin-configs.devdocs")
		end,
	},
	{
		"jemag/nvim-jsonnet",
		branch = "local-setup",
		config = function()
			require("plugin-configs.nvim-jsonnet")
		end,
	},
    {
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "bundled_build.lua",  -- Bundles `mcp-hub` binary along with the neovim plugin
		config = function()
			require("mcphub").setup({
				use_bundled_binary = true,  -- Use local `mcp-hub` binary
			})
		end,
	}, -- {
	{
		"cuducos/yaml.nvim",
		opts = {
			ft = { "yaml", "yaml.helm-values" },
		},
		ft = { "yaml", "yaml.helm-values" }, -- optional
		keys = {
			{ "<leader>yv", "<cmd>YAMLView<cr>", desc = "Yaml view" },
			{ "<leader>yyk", "<cmd>YAMLYankKey +<cr>", desc = "Yank key" },
			{ "<leader>yyv", "<cmd>YAMLYankValue +<cr>", desc = "Yank value" },
			{ "<leader>yyf", "<cmd>YAMLYank +<cr>", desc = "Yank full" },
			{ "<leader>ys", "<cmd>YAMLSnacks<cr>", desc = "Yaml search" },
		},
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter" },
			{ "folke/snacks.nvim" }, -- optional
		},
	},
	{
		-- "someone-stole-my-name/yaml-companion.nvim",
		"astephanh/yaml-companion.nvim",
		branch = "kubernetes_crd_detection",
		lazy = true,
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("yaml_schema")
			require("plugin-configs.yaml-companion")
		end,
		ft = { "yaml", "json" },
	},
	{
		"linrongbin16/gitlinker.nvim",
		config = function()
			require("plugin-configs.gitlinker")
		end,
		lazy = true,
		keys = {
			{ mode = { "n", "x" }, "<leader>gly", "<cmd>GitLink<cr>", silent = true, noremap = true, desc = "Copy git permlink to clipboard" },
			{ mode = { "n", "x" }, "<leader>glg", "<cmd>GitLink!<cr>", silent = true, noremap = true, desc = "Open git permlink in browser" },
			-- blame
			{
				mode = { "n", "x" },
				"<leader>glb",
				"<cmd>GitLink blame<cr>",
				silent = true,
				noremap = true,
				desc = "Copy git blame link to clipboard",
			},
			{
				mode = { "n", "x" },
				"<leader>glB",
				"<cmd>GitLink! blame<cr>",
				silent = true,
				noremap = true,
				desc = "Open git blame link in browser",
			},
		},
	},
	{
		"grafana/vim-alloy",
		ft = { "alloy" },
	}
})
