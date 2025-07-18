--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]symbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]symbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-q>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
	"angular-language-server",
	-- "ansible-language-server",
	-- "azure-pipelines-language-server",
	"bash-language-server",
	"bicep-lsp",
	"clangd",
	"codespell",
	"delve",
	"dockerfile-language-server",
	"editorconfig-checker",
	"eslint_d",
	"gofumpt",
	"goimports",
	"goimports-reviser",
	"golangci-lint",
	"golangci-lint-langserver",
	"golines",
	"gomodifytags",
	"gopls",
	"gotests",
	"gotestsum",
	"hadolint",
	"helm-ls",
	"html-lsp",
	"iferr",
	"impl",
	"java-debug-adapter",
	"java-test",
	"jdtls",
	"json-lsp",
	"jsonnet-language-server",
	"lua-language-server",
	"marksman",
	"prettier",
	"pyright",
	"revive",
	"rust-analyzer",
	"stylua",
	"terraform-ls",
	"tflint",
	"typescript-language-server",
	"vim-language-server",
	"yaml-language-server",
	"yamlls",
	"yamlfmt",
}
-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
local default_options = {
	capabilities = capabilities,
	on_attach = on_attach,
}

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

require("mason-lspconfig").setup({
  ensure_installed = {},
  automatic_enable = false,
})
require("mason-tool-installer").setup({
	ensure_installed = servers,
})

local lspconfig = require("lspconfig")
local installed_servers = require("mason-lspconfig").get_installed_servers()

local function setup_servers()
  for _, name in pairs(installed_servers) do
    -- Create a new options table for each server
    local options = vim.deepcopy(default_options)

    if name == "gopls" then
      local gopls_opts = require("plugin-configs.lsp.gopls")
      options = vim.tbl_deep_extend("force", options, gopls_opts)
    end
    if name == "lua_ls" then
      options = require("plugin-configs.lsp.lua_ls")
    end
    if name == "jsonnet_ls" then
      local jsonnetls_opts = require("plugin-configs.lsp.jsonnetls")
      options = vim.tbl_deep_extend("force", options, jsonnetls_opts)
    end
    if name == "yamlls" then
      local yamlls_opts = require("yaml-companion").setup({
        lspconfig = {
          settings = {
            yaml = {
              format = {
                enable = false,
              },
            },
          },
        },
      })
      options = vim.tbl_deep_extend("force", options, yamlls_opts)
    end

    lspconfig[name].setup(options)
  end
end

setup_servers()
