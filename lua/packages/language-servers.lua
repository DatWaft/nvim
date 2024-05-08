-- For some reason there are lots of warnings for missing fields in this file when neodev is active.
---@diagnostic disable: missing-fields
local function config()
  local lsp = require("lspconfig")

  -- Add borders to LSP windows
  require("lspconfig.ui.windows").default_options.border = border

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
  }

  -- Configure some language servers with the default configuration
  for _, server in ipairs({
    "ansiblels",
    "basedpyright",
    "bashls",
    "biome",
    "clojure_lsp",
    "cmake",
    "cssls",
    "dockerls",
    "emmet_language_server",
    "eslint",
    "gleam",
    "gopls",
    "hls",
    "html",
    "jdtls",
    "kotlin_language_server",
    "lua_ls",
    "ocamllsp",
    "r_language_server",
    "rnix",
    "robotframework_ls",
    "ruff_lsp",
    "rust_analyzer",
    "svelte",
    "taplo",
    "vimls",
    "zls",
  }) do
    lsp[server].setup({ capabilities = capabilities, handlers = handlers })
  end

  -- C languages
  lsp.clangd.setup({
    filetypes = {
      "c",
      "cpp",
      "objc",
      "objcpp",
      "cuda",
    },
    capabilities = capabilities,
    handlers = handlers,
  })
  -- Lua
  lsp.lua_ls.setup({
    settings = {
      Lua = {
        telemetry = { enable = false },
        hint = { enable = true },
      },
    },
    capabilities = capabilities,
    handlers = handlers,
  })
  -- Fennel
  lsp.fennel_ls.setup({
    root_dir = function(filename, _)
      return vim.fs.root(filename, { ".git", "fnl", ".nfnl.fnl" })
    end,
    settings = { ["fennel-ls"] = { ["extra-globals"] = "vim" } },
    capabilities = capabilities,
    handlers = handlers,
  })
  -- JavaScript
  require("lspconfig.configs").vtsls = require("vtsls").lspconfig
  lsp.vtsls.setup({
    settings = {
      javascript = {
        inlayHints = {
          parameterNames = { enabled = "literals" },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "literals" },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
    capabilities = capabilities,
    handlers = handlers,
  })
  -- VueJS
  lsp.volar.setup({
    ---@param new_config object
    ---@param new_root_dir string
    on_new_config = function(new_config, new_root_dir)
      local util = require("lspconfig.util")

      -- Read file synchronously
      -- See |uv_fs_t|
      ---@param path string
      ---@return string
      local function read_file(path)
        local fd = assert(vim.uv.fs_open(path, "r", 438))
        local stat = assert(vim.uv.fs_fstat(fd))
        local data = assert(vim.uv.fs_read(fd, stat.size))
        assert(vim.uv.fs_close(fd))
        return data
      end

      -- Here we are assuming you are using asdf for managing the global node version
      local tool_versions = read_file(vim.env.HOME .. "/.tool-versions")
      local node_version = tool_versions:match("nodejs (%S+)")

      local global_node = vim.env.HOME .. "/.asdf/installs/nodejs/" .. node_version .. "/lib/node_modules"
      local local_node = util.find_node_modules_ancestor(new_root_dir)

      local global_typescript = global_node .. "/typescript/lib"
      local local_typescript = local_node .. "/typescript/lib"

      if util.path.exists(local_typescript) then
        new_config.init_options.typescript.tsdk = local_typescript
      elseif util.path.exists(global_typescript) then
        new_config.init_options.typescript.tsdk = global_typescript
      end
    end,
  })
  -- JSON
  lsp.jsonls.setup({
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
    capabilities = capabilities,
    handlers = handlers,
  })
  -- YAML
  lsp.yamlls.setup({
    settings = {
      yaml = {
        schemaStore = { enable = false, url = "" },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
    capabilities = capabilities,
    handlers = handlers,
  })
end

---@type LazySpec
return {
  -- Configuration
  {
    "neovim/nvim-lspconfig",
    config = config,
    dependencies = {
      { "j-hui/fidget.nvim", opts = { notification = { window = { winblend = 0 } } } },
      "b0o/schemastore.nvim",
      { "folke/neodev.nvim", config = true },
      "folke/neoconf.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "smjonas/inc-rename.nvim", config = true },
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = { automatic_installation = true },
      },
      "yioneko/nvim-vtsls",
    },
  },
  -- Automatic installation
  {
    "williamboman/mason.nvim",
    config = true,
  },
  -- Project-local settings
  { "folke/neoconf.nvim", config = true },
  -- Support LSP file operations
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-neo-tree/neo-tree.nvim" },
    config = true,
  },
  -- Open 'textDocument/documentLink' with gx
  {
    "icholy/lsplinks.nvim",
    config = true,
    lazy = false,
    keys = function()
      return { { "gx", require("lsplinks").gx } }
    end,
  },
  -- Dim unused parameters
  {
    "askfiy/lsp_extra_dim",
    event = "LspAttach",
    opts = { disable_diagnostic_style = "all" },
  },
}
