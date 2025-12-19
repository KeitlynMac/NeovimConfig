local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
local dap = require('dap')

-- 1. Configurar adaptador de Python
require('dap-python').setup(mason_path)

-- Opcional: Usar la terminal integrada para ver los prints más claro
dap.defaults.python.terminal_win_cmd = "belowright new" 

-- 2. ATAJOS DE TECLADO
local opts = { noremap = true, silent = true, buffer = 0 }

-- F5: Iniciar / Continuar
vim.keymap.set('n', '<F5>', function() dap.continue() end, opts)

-- F10, F11, F12 (Pasos de depuración)
vim.keymap.set('n', '<F10>', function() dap.step_over() end, opts)
vim.keymap.set('n', '<F11>', function() dap.step_into() end, opts)
vim.keymap.set('n', '<F12>', function() dap.step_out() end, opts)

-- Leader + b: Breakpoint
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, opts)

-- === AQUÍ ESTÁ LA SOLUCIÓN PARA F4 ===
-- F4: Terminar la sesión de depuración y cerrar la interfaz gráfica
vim.keymap.set({'n', 't'}, '<F4>', function() 
    dap.terminate() 
    dap.close()
    vim.cmd('bd!') -- Cierra el buffer actual si quedó abierto
end, opts)

-- Leader + r: Ejecutar normal (sin debug) en terminal flotante
-- (Requiere que tengas toggleterm configurado, si no, usa :TermExec)
vim.keymap.set('n', '<leader>r', '<cmd>TermExec cmd="python3 %"<CR>', opts)
