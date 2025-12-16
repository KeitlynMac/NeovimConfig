local cmp = require('cmp')
local lspkind = require('lspkind')
local lspconfig = require('lspconfig') -- <--- ESTA LÍNEA FALTABA y causaba el error

-- -------------------------------------------------------------------
-- 1. CONFIGURACIÓN VISUAL Y DE COMPORTAMIENTO (CMP)
-- -------------------------------------------------------------------
cmp.setup({
  -- Limita la lista a solo 10 resultados (para que no sea gigante)
  performance = {
      max_view_entries = 10,
  },

  snippet = {
    expand = function(args)
       require('luasnip').lsp_expand(args.body) 
       -- Si usas vsnip descomenta abajo y comenta arriba:
       -- vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  window = {
    completion = cmp.config.window.bordered({
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    }),
    documentation = cmp.config.window.bordered({
        border = "rounded",
    }),
  },

  -- CONFIGURACIÓN DE ICONOS (LSPKIND)
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- Muestra icono + texto
      maxwidth = 50, 
      ellipsis_char = '...',
      menu = ({
          buffer = "[Buf]",
          nvim_lsp = "[LSP]",
          luasnip = "[Snip]",
          path = "[Path]",
      })
    })
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), 
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 10 },
    { name = 'luasnip', priority = 7 },
    { name = 'buffer', priority = 5 },
    { name = 'path', priority = 5 },
  })
})

-- Búsqueda con / (Usando buffer)
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'buffer' } }
})

-- (La sección de ':' cmdline la omitimos intencionalmente para que NOICE se vea bien)

-- -------------------------------------------------------------------
-- 2. CONFIGURACIÓN DE SERVIDORES (LSP)
-- -------------------------------------------------------------------
-- Definimos las capacidades y atajos comunes
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

-- Configuración de tus lenguajes
local servers = { 'ts_ls', 'html', 'cssls', 'sqlls', 'intelephense' }

for _, server in ipairs(servers) do
    lspconfig[server].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- Configuración especial para Emmet (HTML rápido)
lspconfig.emmet_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {'html', 'css', 'javascriptreact', 'typescriptreact', 'vue', 'svelte'},
}
