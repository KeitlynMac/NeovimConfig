
-- 1. Configuración del Plugin Inc-Rename
require("inc_rename").setup {
  -- Crucial: Usa el grupo de resaltado 'Substitute' para el efecto visual
  hl_group = "Substitute", 
  
  -- Para que la caja de texto se vea bonita (usa tu plugin de diálogo)
  input_buffer_type = "dressing",
  
  -- Muestra el mensaje de cuántas instancias se renombraron
  show_message = true,
  
  -- Otras opciones
  cmd_name = "IncRename",
  preview_empty_name = false,
  save_in_cmdline_history = true,
}


-- 2. Mapeo del Renombrado (Llamada Directa al comando del Plugin)
-- Esto usa el comando directo de IncRename, que es más seguro que interceptar el nativo.
vim.keymap.set("n", "<space>m", function()
  -- Si el renombrado falla, no cerramos Neovim.
  pcall(vim.lsp.buf.rename)
end, { desc = "Refactorizar (LSP Estable)" })



