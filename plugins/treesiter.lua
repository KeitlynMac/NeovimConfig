 -------------------------------------------------------------------
--CONFIGURACIÓN DE TREESITTER
 -------------------------------------------------------------------

-- Intentamos cargar treesitter de forma segura
local status_ok, configs = pcall(require, "nvim-treesitter.configs")

-- Si no se encuentra el plugin, detenemos la ejecución para evitar errores
if not status_ok then
  return
end

configs.setup {
  -- Lista de lenguajes que SIEMPRE deben estar instalados.
  -- He añadido los básicos de Neovim y los de tu carrera (Java, Web).
  ensure_installed = { 
    "c", "lua", "vim", "vimdoc", "query", -- Esenciales para que Neovim no falle
    "java", 
    "javascript", 
    "typescript", 
    "html", 
    "css", 
    "json", 
    "sql" 
  },

  -- Instalar automáticamente parsers si abres un archivo de un lenguaje nuevo
  auto_install = true,

  -- Instalación síncrona (false es más rápido, true evita bloqueos en PCs lentas)
  sync_install = false,

  highlight = {
    enable = true, -- ¡IMPORTANTE! Esto activa el coloreado
    
    -- Desactivamos el resaltado estándar de Vim para que Treesitter tome el control
    additional_vim_regex_highlighting = false,
  },

  -- Módulo de indentación (mejora la indentación con el signo '=')
  indent = { enable = true },

  -- Si usas el plugin 'nvim-ts-autotag' (para cerrar etiquetas HTML), descomenta esto:
  autotag = { enable = true },
}

