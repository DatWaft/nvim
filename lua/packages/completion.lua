-- Check if cursor is inside an string
---@return boolean
local function is_inside_string()
  local context = require("cmp.config.context")
  return context.in_treesitter_capture("string") or context.in_syntax_group("String")
end

-- Check if cursor is inside a comment
---@return boolean
local function is_inside_comment()
  local context = require("cmp.config.context")
  return context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
end

---@param self LazyPlugin
---@param opts table
local function config(self, opts)
  local cmp = require("cmp")

  ---@type table<string, cmp.SourceConfig>
  local sources = {
    lsp = { name = "nvim_lsp" },
    luasnip = {
      name = "luasnip",
      entry_filter = function()
        return not is_inside_string() and not is_inside_comment()
      end,
    },
    path = { name = "path" },
    buffer = {
      name = "buffer",
      option = { keyword_pattern = [[\k\+]] },
    },
    vimtex = { name = "vimtex" },
  }

  cmp.setup({
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      sources.lsp,
      sources.luasnip,
      sources.path,
    }, {
      sources.buffer,
    }),
    mapping = cmp.mapping.preset.insert({
      -- Scrolling
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      -- Completion
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<Space>"] = cmp.mapping.confirm({ select = false }),
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
  })

  cmp.setup.filetype("tex", {
    sources = cmp.config.sources({
      sources.vimtex,
      sources.luasnip,
      sources.path,
    }, {
      sources.buffer,
    }),
  })
end

---@type LazySpec
return {
  {
    "hrsh7th/nvim-cmp",
    config = config,
    init = function()
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
    end,
    dependencies = {
      -- Snippets
      { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
      -- Sources
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "micangl/cmp-vimtex",
    },
  },
  {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
