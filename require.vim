
lua <<EOF
    require('trouble').setup {}


  -- Configuración de Plugins Mayores
  require("nvim-autopairs").setup{}

  -- MASON y LSP (DEBEN IR JUNTOS)
  require'mason'.setup{}
  -- require'nvim-lsp-installer'.setup {} -- ¡OBSOLETO!

  
  -- DAP (DEBE IR ÚLTIMO en la sección de configuración)
  local status_dap_ui, dap_ui = pcall(require, 'nvim-dap-ui')
  if status_dap_ui then
      dap_ui.setup{}
      -- Aquí va toda la configuración de listeners y Java DAP (del paso anterior)
      require('dap').listeners.after.event_initialized["dapui_config"] = function()
          dap_ui.open()
      end
      -- ...
  end
    

  -- EN TU ARCHIVO LUA (require.vim o plug-conf.vim)

-- 1. Definir los íconos de diagnóstico (son los mismos que usas en trouble.nvim)
local signs = {
  Error = "‼️",  
  
  -- U+F071: Advertencia (triángulo con !)
  -- U+E002: Alternativa: "!"
  Warn = "⚠️",   
  
  -- U+F0EB: Hint (Bombilla)
  
  -- U+F05A: Información (círculo con i)
  Info = "ℹ️",
}

-- 2. Configurar los signos nativos de Neovim (la columna izquierda)
for type, icon in pairs(signs) do
  local name = "DiagnosticSign" .. type
  
  -- Define el signo para Neovim:
  vim.fn.sign_define(name, {
    text = icon,         -- El ícono que se mostrará (ej: )
    texthl = name,       -- Grupo de resaltado para el ícono
    numhl = '',          -- <<-- CLAVE: No resaltar el número de línea
  })
end


-- Usamos pcall para intentar cargar el plugin de forma segura
local status_ok, configs = pcall(require, "nvim-treesitter.configs")

-- Si el plugin no está instalado (status_ok es false), detenemos la ejecución AQUÍ
if not status_ok then
  return
end

-- Si pasa el if, significa que el plugin existe, entonces configuramos:
configs.setup {
  ensure_installed = { "java", "html", "css", "javascript" },
  ignore_install = { "lua", "vim", "vimdoc", "query" }, -- Ignoramos los rotos
  sync_install = false,
  highlight = { 
    enable = true,
    disable = { "lua", "vim", "vimdoc", "query" }, -- Desactivamos resaltado roto
  },
  indent = { enable = true },
}

EOF
" FIN DEL ÚNICO BLOQUE LUA
