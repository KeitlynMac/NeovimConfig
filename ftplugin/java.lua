local jdtls = require('jdtls')
local home = os.getenv('HOME')
local mason_path = vim.fn.stdpath("data") .. "/mason/packages"

-- ==========================================================
-- 1. RUTAS DINÁMICAS (Debugger y Tests)
-- ==========================================================
local debug_adapter_path = mason_path .. "/java-debug-adapter"
local debug_jar = vim.fn.glob(debug_adapter_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar")

local java_test_path = mason_path .. "/java-test"
local test_jars = vim.fn.glob(java_test_path .. "/extension/server/*.jar", true)

local bundles = {}
if debug_jar ~= "" then
    table.insert(bundles, debug_jar)
end
for _, jar in ipairs(vim.split(test_jars, "\n")) do
    if jar ~= "" then table.insert(bundles, jar) end
end

-- ==========================================================
-- 2. CONFIGURACIÓN DEL SERVIDOR
-- ==========================================================
local launcher_jar = vim.fn.glob(mason_path .. '/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')
local config_os = mason_path .. '/jdtls/config_linux' -- Ajusta a config_mac o config_win si es necesario

local root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'})
if not root_dir then root_dir = vim.fn.getcwd() end

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = home .. '/.cache/jdtls-workspace/' .. project_name .. "_" .. vim.fn.sha256(root_dir)

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
            inlayHints = {
                parameterNames = { enabled = "all" }
            },
            format = {
                enabled = true,
                settings = {
                    url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },
        }
    },

    on_attach = function(client, bufnr)
        local opts = { silent = true, buffer = bufnr }

        -- 3. INICIAMOS EL DEBUGGER
        if debug_jar ~= "" then
            require('jdtls').setup_dap({ hotcodereplace = 'auto' })
            require('jdtls.dap').setup_dap_main_class_configs()
        end

        local dap = require('dap')
        dap.defaults.java.config = {
            console = "integratedTerminal",
        }

        -- Atajos estándar
        vim.keymap.set('n', '<leader>jo', require('jdtls').organize_imports, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
        
        -- Ejecutar Debug (F5)
        vim.keymap.set('n', '<F5>', function() 
            if vim.tbl_count(dap.configurations.java or {}) == 0 then
                require('jdtls.dap').setup_dap_main_class_configs()
            end
            dap.continue() 
        end, opts)

        -- ==========================================================
        -- 4. TUS ATAJOS RESTAURADOS (<F4> para salir)
        -- ==========================================================
        -- F4 en modo Normal: Cierra el buffer forzosamente
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F4>', ':bd!<CR>', { noremap = true, silent = true })

        -- F4 en modo Terminal: Sale del modo terminal y cierra el buffer
        vim.api.nvim_buf_set_keymap(bufnr, 't', '<F4>', '<C-\\><C-n>:bd!<CR>', { noremap = true, silent = true })
    end
}

jdtls.start_or_attach(config)

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.java",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- ==========================================================
-- 5. CONFIGURACIÓN VISUAL DEL DEBUGGER (DAP-UI)
-- ==========================================================
local status_ok, dapui = pcall(require, "dapui")
if status_ok then
    -- Configuramos los botones visuales estilo IDE
    dapui.setup({
        controls = {
            element = "repl",
            enabled = true,
            icons = {
                pause = "⏸️",
                play = "▶️",
                step_into = "󰆹",
                step_over = "⏭️",
                step_out = "󰆸",
                step_back = "",
                run_last = "↻",
                terminate = "⏹️",
                disconnect = "⏏️",
            }
        }
    })

    local dap = require('dap')

    -- Eventos para abrir la UI automáticamente al presionar F5
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    
    -- Eventos para cerrar la UI automáticamente al terminar
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end
