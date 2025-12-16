 --- CONFIGURACIÓN NVIM-TREE (FULL COLOR & SYMBOLS) ---
require("nvim-tree").setup({
    
    sync_root_with_cwd = true, 


    actions = {
        open_file = {
            quit_on_open = true, -- ¡ESTO! Cierra el árbol al abrir un archivo
        },
    },

    renderer = {
    root_folder_label = false,
    
    -- 1. ACTIVAR COLORES EN EL TEXTO (NOMBRES)
    highlight_git = true,         -- Colorea el nombre si el archivo cambió en Git
    highlight_opened_files = "name", -- Colorea el nombre si el archivo está abierto
    highlight_diagnostics = true, -- Colorea el nombre si tiene errores (Rojo/Amarillo)
    highlight_modified = "name",  -- Colorea si no has guardado cambios
    
    indent_markers = {
      enable = true,
      inline_arrows = false,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        none = " ",
      },
    },
    icons = {
      show = {
        git = true,       -- Mostrar iconos de estado (pequeños)
        file = true,
        folder = true,
        folder_arrow = true,
        diagnostics = true, -- Mostrar icono de error al lado del archivo
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          -- Iconos de estado minimalistas
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  
  -- 2. CONFIGURACIÓN DE DIAGNÓSTICOS (ERRORES)
  diagnostics = {
    enable = true,
    show_on_dirs = true, -- Pinta la carpeta roja si hay un error dentro
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },

  -- 3. COMPORTAMIENTO
  disable_netrw = true,
  hijack_netrw = true,
  sync_root_with_cwd = true,
  
  view = {
    width = 30,
    side = "left",
    signcolumn = "yes", -- Mantiene el padding a la izquierda
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
})



 --- CONFIGURACIÓN DE ICONOS ESTILO VSCODE SYMBOLS ---
  --- CONFIGURACIÓN DE ICONOS PERSONALIZADOS (POR NOMBRE) ---
require'nvim-web-devicons'.setup {
 -- override: Aquí defines tus reglas personalizadas
 override = {
  -- 1. TUS CARPETAS PERSONALIZADAS (Lo que pediste)
  ["logic"] = {
    icon = "",      -- Un microchip/cerebro para lógica
    color = "#e74c3c", -- Rojo suave
    name = "Logic"
  },
  ["gui"] = {
    icon = "憎",      -- Un panel de interfaz
    color = "#3498db", -- Azul interfaz
    name = "Gui"
  },
  ["model"] = {
    icon = "",      -- Estructura de datos
    color = "#f1c40f", -- Amarillo
    name = "Model"
  },
  ["controller"] = {
    icon = "ﬤ",      -- Nodos/Controlador
    color = "#9b59b6", -- Morado
    name = "Controller"
  },

  -- 2. CARPETAS ESTÁNDAR (Las de la vez pasada)
  ["src"] = {
    icon = "",
    color = "#e67e22",
    name = "src"
  },
  ["assets"] = {
    icon = "",
    color = "#2ecc71",
    name = "Assets"
  },
  [".git"] = {
    icon = "",
    color = "#e74c3c",
    name = "GitFolder"
  },
  [".github"] = {
    icon = "",
    color = "#7f8c8d",
    name = "Github"
  },
  ["node_modules"] = {
    icon = "",
    color = "#27ae60",
    name = "NodeModules"
  },
  ["public"] = {
    icon = "",
    color = "#9b59b6",
    name = "Public"
  },
 }
}

