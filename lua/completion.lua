local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
local lspkind = require("lspkind")

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  formatting = { format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }) },
  window = {
    completion = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
    }),
    documentation = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
    }),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
 
  }),
})
