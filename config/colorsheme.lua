-- -- --- TEMA KANAGAWA (VARIANTE DRAGON/NEGRO) ---
--  require('kanagawa').setup({
--      compile = true,
--      undercurl = true,
--      commentStyle = { italic = true },
--      functionStyle = {},
--      keywordStyle = { italic = true},
--      statementStyle = { bold = true },
--      typeStyle = {},
--      transparent = true,     -- Pon true si quieres usar el negro de tu terminal Kitty
--      dimInactive = false,
--      terminalColors = true,
  
--      -- AQUÍ ESTÁ LA MAGIA PARA EL COLOR NEGRO
--      theme = "dragon",        -- Seleccionamos la variante oscura
--      background = {
--          dark = "dragon",     -- Forzamos que el modo oscuro use Dragon
--          light = "lotus"
--      },
  
--      -- Opcional: Si quieres un negro ABSOLUTO (OLED Black), descomenta esto:
--      -- overrides = function(colors)
--      --     return {
--      --         Normal = { bg = "#000000" },
--      --         Floating = { bg = "#000000" },
--      --         Gutter = { bg = "#000000" },
--      --     }
--      -- end,
--  })
--  -- Activar el tema
--  vim.cmd("colorscheme kanagawa")


 -- -------------------------------------------------------------------
-- CONFIGURACIÓN DEL TEMA EVERFOREST
-- -------------------------------------------------------------------

-- 1. Asegurar colores verdaderos
vim.opt.termguicolors = true
vim.opt.background = "dark" 

-- 2. Opciones de personalización (vim.g)
-- Estas variables deben ir ANTES de llamar a colorscheme

-- Modo de fondo: 'hard', 'medium' (por defecto), o 'soft'
-- 'soft' es el más suave para los ojos
vim.g.everforest_background = 'hard' 

-- Contraste: 'normal' (default), 'high', o 'low'
vim.g.everforest_contrast = 'normal'

-- Estilos: Cursiva para comentarios
vim.g.everforest_enable_italic = 1
vim.g.everforest_comments = 'italic' 

-- Color de las líneas de indentación (para que sean visibles)
vim.g.everforest_disable_cursorline = 0
vim.g.everforest_cursor_text_color = 1 

-- 3. ACTIVAR EL TEMA
vim.cmd("colorscheme everforest")



--------- BARRA DE ESTADO (LUALINE) ----------
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto', -- ¡Truco! Detecta automáticamente Kanagawa Dragon
    
    -- Separadores redondeados (Estilo moderno)
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    
    disabled_filetypes = {
      statusline = { 'alpha', 'dashboard', 'NvimTree', 'Outline' }, -- No mostrar barra en el dashboard
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true, -- UNA sola barra para todas las ventanas (Estilo VS Code)
  },
  sections = {
    lualine_a = { 
        { 'mode', separator = { left = '' }, right_padding = 2 } 
    },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = {
        { 'location', separator = { right = '' }, left_padding = 2 }
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = { 'nvim-tree', 'quickfix' } -- Soporte para barra lateral si la usas
}

--- TABS SUPERIORES (BUFFERLINE) ---
require("bufferline").setup{
    options = {
        mode = "buffers",
        
        -- AQUÍ ESTÁ EL ESTILO UNDERLINE QUE PEDISTE
        indicator = {
            style = 'underline', -- Pone una línea debajo de la pestaña activa
        },
        
        -- Separadores (puedes probar "slant", "thick" o "thin")
        separator_style = "thin",
        
        -- Integración con tus errores de Java (Muestra puntos rojos si hay errores)
        diagnostics = "nvim_lsp",
        
        -- Iconos y estilo
        show_buffer_close_icons = false, -- Limpia visualmente (quita la X de cada tab)
        show_close_icon = false,         -- Quita la X grande de la derecha
        always_show_bufferline = true,
        
        -- Si usas NvimTree, esto hace que la barra se mueva a la derecha para no taparlo
        offsets = {
            {
                filetype = "NvimTree",
                text = "Explorador",
                text_align = "left",
                separator = true
            }
        }
    },
}

--- GUÍAS DE INDENTACIÓN (INDENT BLANKLINE v3) ---
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup {
    -- 1. Apariencia de la línea
    indent = {
        char = "│",  -- Caracter limpio
        -- tab_char = "│",
    },

    -- 2. Configuración del SCOPE (Lo que pediste)
    scope = {
        enabled = true,      -- Activa el resaltado del contexto actual
        show_start = true,  -- true si quieres una raya horizontal al inicio del if
        show_end = false,    -- true si quieres una raya horizontal al final del if
        highlight = highlight, -- Usa los colores definidos arriba (opcional, o usa nil)
    },

    -- 3. Donde NO mostrar las líneas (para que no se vea feo el dashboard)
    exclude = {
        filetypes = {
            "dashboard",
            "alpha",
            "NvimTree",
            "help",
            "terminal",
            "mason",
            "lazy",
        },
    },
}


