-- Esto va en un archivo nuevo o en tu ui.lua
require("barbecue").setup({
  create_autocmd = false, -- Evita que se adjunte automáticamente para no dar errores
})

vim.api.nvim_create_autocmd({
  "WinResized", 
  "BufWinEnter",
  "CursorHold",
  "InsertLeave",
}, {
  group = vim.api.nvim_create_augroup("barbecue.updater", {}),
  callback = function()
    require("barbecue.ui").update()
  end,
})
