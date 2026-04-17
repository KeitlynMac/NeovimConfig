-- ~/.config/nvim/plugins/snacks.lua
-- Función para crear proyecto
local function create_new_project()
    vim.ui.input({ prompt = "Nombre del Proyecto Java: " }, function(input)
        if input and input ~= "" then
            vim.cmd("JavaNuevo " .. input)
        end
    end)
end

-- 1. Inicializar y activar los módulos deseados
require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    width = 80, 
    preset = {
      -- Eliminé el arte ASCII del header de aquí para mantener el código más limpio
      keys = {
        -- Snacks.picker.projects() busca en los directorios recientes
        { icon = "🗃️ ", key = "a", desc = "Proyectos Recientes", action = ":lua Snacks.picker.projects()" },
        
        { icon = "📂 ", key = "n", desc = "New file",            action = ":ene | startinsert" },
        
        -- Le pasamos cwd = '~' para que busque archivos desde tu carpeta HOME, reemplazando el :cd $HOME
        { icon = "📄 ", key = "f", desc = "Find file",           action = ":lua Snacks.picker.files({ cwd = '~' })" },
        
        -- Snacks.picker.recent() es el equivalente directo a Telescope oldfiles
        { icon = "📌 ", key = "r", desc = "Recent",              action = ":lua Snacks.picker.recent()" },
        
        { icon = "☕ ", key = "c", desc = "Crear Proyecto Java", action = create_new_project },
        { icon = "💼 ", key = "p", desc = "Proyectos Java",      action = ":lua Snacks.explorer({ cwd = '~/Programming/Practicas/' })" },
        { icon = "⚙️ ", key = "v", desc = "Config",              action = ":lua Snacks.explorer({ cwd = '~/.config/nvim' })" },
        { icon = " ", key = "q", desc = "Quit",                action = ":qa" },
      },
    },
    sections = {
      -- PANEL IZQUIERDO
      -- (Ya no está la sección "header" aquí)
      {
        section = "terminal",
        -- Aumenté el alto en --size de 18 a 28 para que la imagen ocupe todo el espacio vertical
        cmd = "chafa ~/.config/nvim/lago.jpg --format symbols --symbols vhalf --size 80x28 --stretch; sleep .1",
        height = 28, -- También aumentamos la altura de la sección para que coincida
        padding = 1,
      },

      -- PANEL DERECHO (pane = 2)
      { pane = 2, icon = " ", title = "Opciones",         section = "keys",         indent = 2, padding = 1 },
      { pane = 2, icon = " ", title = "Recientes",         section = "recent_files", indent = 2, padding = 1 },
      { pane = 2, icon = " ", title = "Proyectos",        section = "projects",     indent = 2, padding = 1 },

      -- FOOTER CENTRADO
      function()
        local version = vim.version()
        local print_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
        local date = os.date("%d-%m-%Y")
        return {
          align = "center",
          text = {
            { "Hola Keitlyn | Neovim " .. print_version .. "  |  " .. date, hl = "SnacksDashboardFooter" }
          },
        }
      end,
    },
  },
  
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  picker = { 
    enabled = true,
    sources = {
      explorer = {
        jump = { close = true }, 
      }
    }
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  rename = { enabled = true }, 
})

-- 2. Configurar atajos de teclado (Keymaps)
local map = vim.keymap.set

-- Explorador y Búsqueda (Pickers)
map("n", "<space>e", function() Snacks.explorer() end, { desc = "File Explorer" })
map("n", "<space>ff", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
map("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
-- Utilidades

-- Git
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
map({"n", "v"}, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })

-- Utilidades
map("n", "<leader>z", function() Snacks.zen() end, { desc = "Toggle Zen Mode" })
map("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
map("n", "<c-/>", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
map("n", "<space>h", function() Snacks.dashboard() end, { desc = "Open Dashboard" })

-- ==========================================
-- Snacks: Words (Navegar entre referencias)
-- ==========================================
-- Si pones el cursor sobre una variable, Snacks la iluminará en todo el archivo. 
-- Con estos atajos puedes saltar a la siguiente coincidencia (]]) o a la anterior ([[)
map({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Siguiente Referencia" })
map({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Referencia Anterior" })

-- ==========================================
-- Snacks: Rename (Renombrar de forma segura)
-- ==========================================
-- Renombra la variable bajo el cursor en todo tu código (usa la interfaz flotante de Snacks)
map("n", "<space>re", function() vim.lsp.buf.rename() end, { desc = "Renombrar Variable" })

-- Extra: Snacks tiene una función genial para renombrar el archivo físico actual
map("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Renombrar Archivo" })

-- Redefinir la función print global para usar las notificaciones mejoradas de Snacks
_G.dd = function(...)
  Snacks.debug.inspect(...)
end
vim.print = _G.dd
