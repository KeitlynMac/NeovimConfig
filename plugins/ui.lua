--- PANTALLA DE INICIO (ALPHA DASHBOARD) ---
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- 1. EL HEADER (Tu arte ASCII)
dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}
-- 2. FUNCIÓN PARA CREAR PROYECTO (La que tú pusiste)
local function create_new_project()
    vim.ui.input({ prompt = "Nombre del Proyecto Java: " }, function(input)
        if input and input ~= "" then
            vim.cmd("JavaNuevo " .. input)
        end
    end)
end
-- 2. LOS BOTONES Y BOOKMARKS
dashboard.section.buttons.val = {
    -- Acciones Principales
    -- Botón 'p': ABRIR EXISTENTE (Telescope Projects)
    dashboard.button("a", "🗃️ ➡️ Proyectos Recientes", ":Telescope projects<CR>"),
    dashboard.button("n", "📂 ➡️ New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "📄 ➡️ Find file", ":cd $HOME | Telescope find_files<CR>"),
    dashboard.button("r", "📌 ➡️ Recent", ":Telescope oldfiles<CR>"),

    -- Espacio y Título de Bookmarks
    { type = "text", val = "─── 📍 Bookmarks ───", opts = { hl = "SpecialComment", position = "center" } },

    dashboard.button("c", "☕ ➡️ Crear Proyecto Java", create_new_project),
    dashboard.button("p", "💼 ➡️ Proyectos Java", ":NvimTreeClose |  NvimTreeOpen ~/Programming/Practicas/<CR>"),
    dashboard.button("v", "⚙️ ➡️ Config", ":NvimTreeClose | NvimTreeOpen ~/.config/nvim<CR>"),
    dashboard.button("q", "❌ ➡️ Quit NVIM", ":qa<CR>"),
}

-- 3. EL PIE DE PÁGINA (Footer)
local function footer()
    -- Muestra versión y fecha
    local version = vim.version()
    local print_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
    local date = os.date("%d-%m-%Y")
    return "Hola Keitlyn | Neovim " .. print_version .. "  |  " .. date
end
dashboard.section.footer.val = footer()

-- 4. APLICAR CONFIGURACIÓN
alpha.setup(dashboard.config)

-- Desactivar plegado de código en el dashboard para que no se vea feo
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])



------------Git---------------------
require('gitsigns').setup({
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
    },
    current_line_blame = true, -- ¡Genial! Te dice quién modificó la línea actual y cuándo (mensaje fantasma a la derecha)
})


-----Ventana de errores---------
-- Configuración existente de Telescope...
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- Opciones visuales
      }
    }
  }
}
-- Cargar la extensión
require("telescope").load_extension("ui-select")


-------------Terminal Flotante-----------------------

require("toggleterm").setup{
  -- El atajo Espacio + t
  open_mapping = [[<C-t>]],
  
  hide_numbers = true,
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  
  float_opts = {
    border = "curved",
    
    -- === AQUÍ SE CONTROLA EL TAMAÑO ===
    -- math.ceil(vim.o.columns * 0.7) significa: El 70% del ancho de tu ventana
    -- math.ceil(vim.o.lines * 0.7)   significa: El 70% del alto de tu ventana
    -- Si la quieres más chica, cambia 0.7 por 0.5
    width = function() return math.ceil(vim.o.columns * 0.5) end,
    height = function() return math.ceil(vim.o.lines * 0.5) end,
    
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}

 --- MENU DE CREACIÓN JAVA (COMPATIBLE CON NVIM-TREE) ---

-- Función auxiliar para obtener la ruta correcta
local function get_target_dir()
    -- 1. Si estamos dentro de NvimTree
    if vim.bo.filetype == "NvimTree" then
        local api = require("nvim-tree.api")
        local node = api.tree.get_node_under_cursor()
        
        if not node then return vim.fn.getcwd() end -- Si falla, devuelve la raíz

        -- Si estás parado sobre una carpeta, usa esa carpeta
        if node.type == "directory" then
            return node.absolute_path
        else
            -- Si estás parado sobre un archivo, usa la carpeta que lo contiene
            return node.parent.absolute_path
        end
    else
        -- 2. Si estamos en un archivo normal de código
        return vim.fn.expand('%:p:h')
    end
end

local function create_java_structure()
    local options = {
        "1. Class",
        "2. Interface",
        "3. Enum",
        "4. Record",
        "5. Package (Solo Carpeta)"
    }

    vim.ui.select(options, { prompt = "Crear en: " .. get_target_dir() }, function(choice)
        if not choice then return end

        local prompt_msg = "Nombre (ej: 'User' o 'model/User'): "
        if choice == "5. Package (Solo Carpeta)" then
            prompt_msg = "Nombre del Paquete: "
        end

        vim.ui.input({ prompt = prompt_msg }, function(input_name)
            if not input_name or input_name == "" then return end

            -- OBTIENE LA RUTA INTELIGENTE (NvimTree o Archivo)
            local current_dir = get_target_dir()
            
            -- LÓGICA DE CREACIÓN (Igual que antes)
            if choice == "5. Package (Solo Carpeta)" then
                local new_dir = current_dir .. "/" .. input_name
                vim.fn.mkdir(new_dir, "p")
                print(">> Carpeta creada: " .. input_name)
                vim.cmd("NvimTreeRefresh") -- Importante para que aparezca
                return
            end

            local dir_part = "."
            local file_name = input_name
            if string.find(input_name, "/") then
                local last_slash = string.find(input_name, "/[^/]*$")
                dir_part = string.sub(input_name, 1, last_slash - 1)
                file_name = string.sub(input_name, last_slash + 1)
            end

            local final_dir = current_dir
            if dir_part ~= "." then
                final_dir = final_dir .. "/" .. dir_part
                vim.fn.mkdir(final_dir, "p")
            end

            local file_path = final_dir .. "/" .. file_name .. ".java"

            local package_name = ""
            if string.find(final_dir, "src/main/java/") then
                package_name = string.match(final_dir, "src/main/java/(.*)")
                package_name = string.gsub(package_name, "/", ".")
            end

            local type_keyword = "class"
            if string.find(choice, "Interface") then type_keyword = "interface"
            elseif string.find(choice, "Enum") then type_keyword = "enum"
            elseif string.find(choice, "Record") then type_keyword = "record" end

            local content = ""
            if package_name ~= "" then content = "package " .. package_name .. ";\n\n" end
            content = content .. "public " .. type_keyword .. " " .. file_name .. " {\n    \n}"

            local file = io.open(file_path, "w")
            if file then
                file:write(content)
                file:close()
                -- Refrescar árbol y abrir archivo
                vim.cmd("NvimTreeRefresh") 
                vim.cmd("edit " .. file_path)
            else
                print("Error creando archivo.")
            end
        end)
    end)
end

-- Comando y Atajo
vim.api.nvim_create_user_command("JavaNew", create_java_structure, {})
vim.api.nvim_set_keymap('n', '<space>c', ':JavaNew<CR>', { noremap = true, silent = true })



----------Atajos-----------------------
--require("which-key").setup({
    -- Esto hace que el menú aparezca más rápido o lento
    --timeoutlen = 500, 
--})


--- GESTOR DE PROYECTOS (PROJECT.NVIM) ---

-- 1. Configuración del plugin Project
require("project_nvim").setup({
  detection_methods = { "pattern" },
  patterns = { ".git", "pom.xml", "package.json", "Makefile", "README.md" },
  manual_mode = false,
})

-- 2. Conectar con Telescope
-- IMPORTANTE: Esto debe ir DESPUÉS de require('telescope').setup(...)
-- (Como lo estás poniendo al final del archivo, seguro ya cargó Telescope antes)
require('telescope').load_extension('projects')

------NOICE----------------------
require("noice").setup({
  messages = {
    view = "mini",
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    progress = {
      enabled = false,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
    inc_rename = false,
  },
  -- ⬇️ AQUÍ ESTÁ LA SOLUCIÓN ⬇️
  views = {
    -- Configuramos la ventana de comandos para que tenga un ancho fijo y estable
    cmdline_popup = {
      position = {
        row = "20%", -- Posición vertical (20% desde arriba)
        col = "50%", -- Centrado horizontalmente
      },
      size = {
        width = 60,  -- Ancho fijo (evita que se encoja o baile)
        height = "auto",
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
    },
    -- Forzamos a que el menú de sugerencias respete el ancho
    popupmenu = {
      relative = "editor",
      position = {
        row = "35%", -- Justo debajo de la cmdline
        col = "50%",
      },
      size = {
        width = 60, -- El mismo ancho que la cmdline para que coincidan
        height = 10,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
      },
    },
  },
})



 -------------------------------------------------------------------
 --CONFIGURACIÓN TIPO ERROR LENS (Tiny Inline Diagnostic)
 -------------------------------------------------------------------

-- 1. Desactivamos el texto virtual nativo para que no se duplique
vim.diagnostic.config({ virtual_text = false })

-- 2. Configuramos el plugin
require('tiny-inline-diagnostic').setup({
    preset = "modern", -- Opciones: "modern", "classic", "powerline", "minimal"
    
    options = {
        show_source = true, -- Muestra "eslint", "java", etc.
        use_icons_from_diagnostic = true, -- Usa tus iconos bonitos
        multilines = true, -- Si el error es largo, lo divide en lineas
        softwrap = 30, -- Ajuste de texto si es muy largo
    },
})


