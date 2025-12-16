local jdtls = require('jdtls')
local home = os.getenv('HOME')

-- Lógica inteligente para definir la raíz del proyecto (Evita el problema de los 2 JDTLS)
local root_dir = (function()
    local root = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'})
    if not root then root = vim.fn.expand('%:p:h') end
    if root == os.getenv('HOME') then return vim.fn.expand('%:p:h') end
    return root
end)()

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = home .. '/.cache/jdtls-workspace/' .. project_name .. "_" .. vim.fn.sha256(root_dir)

-- ==========================================================
-- 1. RUTA DEL DEBUGGER
-- ==========================================================
local debug_jar_path = "/home/nyltiek/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-0.53.2.jar"
local bundles = {}
if vim.fn.filereadable(debug_jar_path) == 1 then
    table.insert(bundles, debug_jar_path)
end

-- ==========================================================
-- 2. CONFIGURACIÓN DEL SERVIDOR
-- ==========================================================
local mason_path = home .. '/.local/share/nvim/mason/packages/jdtls'
local launcher_jar = vim.fn.glob(mason_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local config_os = mason_path .. '/config_linux'

local config = {
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', launcher_jar,
        '-configuration', config_os,
        '-data', workspace_dir
    },

    root_dir = root_dir,

    init_options = {
        bundles = bundles
    },

    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            referencesCodeLens = { enabled = false },
            implementationsCodeLens = { enabled = true },
        }
    },

    on_attach = function(client, bufnr)
        local opts = { silent = true, buffer = bufnr }

        -- ACTIVAR DEBUGGER
        require('jdtls').setup_dap({ hotcodereplace = 'auto' })
        require('jdtls.dap').setup_dap_main_class_configs()
        
        -- CONFIGURACIÓN CLAVE: Usar Terminal Integrada (Solo 1 ventana)
        local dap = require('dap')
        dap.defaults.java.config = {
            console = "integratedTerminal", -- Esto fuerza a usar la terminal normal, no la consola extra
        }

        -- NOTA: He borrado el bloque "dap.listeners... abrir_consola" 
        -- para que NO se abra la segunda ventana duplicada.

        -- Atajos
        vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<F5>', function() require('dap').continue() end, opts)
        vim.keymap.set('n', '<F4>', '<cmd>bd!<CR>', opts)
        -- Si también quieres que funcione estando dentro de la terminal (modo escritura):
        vim.keymap.set('t', '<F4>', '<C-\\><C-n><cmd>bd!<CR>', opts)
        -- Opción A: Estándar de Neovim (Espacio + c + a)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
        -- Opción B: Estilo IntelliJ/VS Code (Alt + Enter)
        -- Nota: En algunas terminales <M-CR> no funciona bien, pero pruébalo.
        vim.keymap.set("n", "<M-CR>", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
        
        -- PROTECCIÓN CONTRA EL ERROR ROJO (pcall)
        if client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = bufnr,
                callback = function()
                    if vim.api.nvim_buf_is_valid(bufnr) then
                        pcall(vim.lsp.codelens.refresh)
                    end
                end,
            })

            -- ... tus atajos anteriores ...

        -- COMANDO DE FORMATO AL GUARDAR
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    -- Esto ordena el código usando el motor de Eclipse/Java
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end
}

jdtls.start_or_attach(config)

-- ==========================================================
--  CONFIGURACIÓN FINAL: F4 PARA CERRAR LA TERMINAL
-- ==========================================================
local dap = require('dap')

-- Esto detecta cuando se abre la terminal y le pega el atajo F4
dap.listeners.after.event_initialized["configurar_f4_terminal"] = function()
    -- Esperamos medio segundo a que la ventana exista
    vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.api.nvim_buf_get_name(buf)
            -- Si encontramos la terminal de Java...
            if name:match("dap%-terminal") then
                -- 1. F4 en modo Normal (si ya saliste del modo escritura)
                vim.api.nvim_buf_set_keymap(buf, 'n', '<F4>', ':bd!<CR>', { noremap = true, silent = true })
                
                -- 2. F4 en modo Terminal (mientras estás escribiendo o viendo logs)
                -- Esto es clave: <C-\><C-n> es el comando para 'salir' de la terminal y luego ejecutamos :bd!
                vim.api.nvim_buf_set_keymap(buf, 't', '<F4>', '<C-\\><C-n>:bd!<CR>', { noremap = true, silent = true })
            end
        end
    end, 500)
end



