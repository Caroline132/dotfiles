-- LSP keymaps via LspAttach autocmd (modern approach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf

    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", require("snacks").picker.lsp_definitions, "[G]oto [D]efinition")
    nmap("gr", require("snacks").picker.lsp_references, "[G]oto [R]eferences")
    nmap("gI", require("snacks").picker.lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>D", require("snacks").picker.lsp_type_definitions, "Type [D]efinition")
    nmap("<leader>ds", require("snacks").picker.lsp_symbols, "[D]ocument [S]symbols")
    nmap("<leader>ws", require("snacks").picker.lsp_workspace_symbols, "[W]orkspace [S]symbols")

    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-q>", vim.lsp.buf.signature_help, "Signature Documentation")

    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
      vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
  end,
})

-- Mason setup for installing tools
require("mason").setup()

-- Tools to install via Mason (formatters, linters, debuggers, etc.)
local tools = {
  "codespell",
  "delve",
  "editorconfig-checker",
  "eslint_d",
  "gofumpt",
  "goimports",
  "goimports-reviser",
  "golangci-lint",
  "golines",
  "gomodifytags",
  "gotests",
  "gotestsum",
  "hadolint",
  "iferr",
  "impl",
  "java-debug-adapter",
  "java-test",
  "prettier",
  "revive",
  "stylua",
  "tflint",
  "yamlfmt",
}

-- LSP servers to install via Mason (using Mason package names)
local servers = {
  "angular-language-server",
  "bash-language-server",
  "bicep-lsp",
  "clangd",
  "dockerfile-language-server",
  "golangci-lint-langserver",
  "gopls",
  "helm-ls",
  "html-lsp",
  "jdtls",
  "json-lsp",
  "jsonnet-language-server",
  "lua-language-server",
  "marksman",
  "pyright",
  "rust-analyzer",
  "terraform-ls",
  "typescript-language-server",
  "vim-language-server",
  "yaml-language-server",
}

require("mason-lspconfig").setup({
  ensure_installed = {},
  automatic_enable = false,
})
require("mason-tool-installer").setup({
  ensure_installed = vim.list_extend(vim.deepcopy(servers), tools),
})

-- Setup neovim lua configuration
require("neodev").setup()

-- Capabilities with blink.cmp
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Default config applied to all servers via wildcard
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- Server-specific configurations using vim.lsp.config
-- Use lspconfig names (e.g., lua_ls, not lua-language-server)

vim.lsp.config("angularls", {})
vim.lsp.config("bashls", {})
vim.lsp.config("bicep", {})
vim.lsp.config("clangd", {})
vim.lsp.config("dockerls", {})
vim.lsp.config("golangci_lint_ls", {})
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})
vim.lsp.config("helm_ls", {})
vim.lsp.config("html", {})
vim.lsp.config("jdtls", {})
vim.lsp.config("jsonls", {})
vim.lsp.config("jsonnet_ls", {
  cmd = { "jsonnet-language-server", "-t" },
  settings = {
    formatting = {
      UseImplicitPlus = false,
    },
  },
})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        disable = { "different-requires" },
        globals = {
          "P",
          "vim",
          "describe",
          "it",
          "before_each",
          "after_each",
          "teardown",
          "pending",
          "clear",
        },
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true,
  },
})
vim.lsp.config("marksman", {})
vim.lsp.config("nushell", {})
vim.lsp.config("pyright", {})
vim.lsp.config("rust_analyzer", {})
vim.lsp.config("terraformls", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("vimls", {})
vim.lsp.config("yamlls", {})

-- Enable all configured servers
vim.lsp.enable("angularls")
vim.lsp.enable("bashls")
vim.lsp.enable("bicep")
vim.lsp.enable("clangd")
vim.lsp.enable("dockerls")
vim.lsp.enable("golangci_lint_ls")
vim.lsp.enable("gopls")
vim.lsp.enable("helm_ls")
vim.lsp.enable("html")
vim.lsp.enable("jdtls")
vim.lsp.enable("jsonls")
vim.lsp.enable("jsonnet_ls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("marksman")
vim.lsp.enable("nushell")
vim.lsp.enable("pyright")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("terraformls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("vimls")
vim.lsp.enable("yamlls")
