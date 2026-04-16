-- Configuración para abrir Lazygit con Toggleterm
local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new({ 
  cmd = "lazygit", 
  hidden = true, 
  direction = "float",
  float_opts = {
    border = "curved",
    -- Calculamos dinámicamente el 90% del tamaño real de tu ventana
    width = math.floor(vim.o.columns * 0.9),
    height = math.floor(vim.o.lines * 0.9),
  },
  on_open = function(term)
    -- Al abrir, entramos en modo terminal automáticamente
    vim.cmd("startinsert!")
    -- Mapeamos 'q' para cerrar la ventana limpiamente
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
})

function _lazygit_toggle()
  lazygit:toggle()
end

-- Atajo: Espacio + gg abre Lazygit
vim.keymap.set("n", "<space>gg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true, desc = "Abrir Lazygit"})
