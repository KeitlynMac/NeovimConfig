local cmp = require('cmp')
local lspkind = require('lspkind')
local lspconfig = require('lspconfig')

-- -------------------------------------------------------------------
-- 1. CONFIGURACIÓN VISUAL (ESTILO VS CODE)
-- -------------------------------------------------------------------
cmp.setup({
  -- Limita resultados para limpieza
  performance = {
      max_view_entries = 20, -- VS Code suele mostrar más, 20 es un buen número
  },
    

  snippet = {
    expand = function(args)
       require('luasnip').lsp_expand(args.body) 
    end,
  },

  -- AQUÍ ESTÁ EL CAMBIO CLAVE: "none" quita los marcos
  window = {
    completion = {
        border = "none", -- Sin bordes visibles
        side_padding = 1, -- Un poco de aire a los lados
        winhighlight = "Normal:DiffChange,FloatBorder:Normal,CursorLine:WildMenu,Search:None",
        scrollbar = false, -- VS Code generalmente no muestra barra de scroll fea
    },
    documentation = {
        border = "none", -- Documentación flotante también limpia
        winhighlight = "Normal:DiffChange,FloatBorder:Normal,CursorLine:WildMenu,Search:None",
    },
  },

  -- -------------------------------------------------------------------
  -- CORRECCIÓN: Estilo VS Code Real (Icono Izq | Nombre | Tipo Der)
  -- -------------------------------------------------------------------
  formatting = {
    fields = { 'kind', 'abbr', 'menu' }, -- Orden de las columnas
    format = function(entry, vim_item)
      local kind = require("lspkind").cmp_format({
        mode = "symbol_text", -- Pedimos icono Y texto a lspkind
        maxwidth = 50,
        symbol_map = { Copilot = "" } -- (Opcional) Por si usas copilot
      })(entry, vim_item)

      -- TRUCO: Separamos el Icono del Texto
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      
      kind.kind = " " .. (strings[1] or "") .. " " -- Columna 1: Solo el Icono
      kind.menu = "    " .. (strings[2] or "")     -- Columna 3: El Texto (Class, Method) a la derecha

      return kind
    end
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

-- Búsqueda con /
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'buffer' } }
})

-- -------------------------------------------------------------------
-- 2. CONFIGURACIÓN DE SERVIDORES (LSP)
-- -------------------------------------------------------------------
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

local servers = { 'ts_ls', 'html', 'cssls', 'sqlls', 'intelephense', 'pyright' }

for _, server in ipairs(servers) do
    lspconfig[server].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

lspconfig.emmet_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {'html', 'css', 'javascriptreact', 'typescriptreact', 'vue', 'svelte', 'pyright'},
}
