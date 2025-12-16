--- ARREGLO PARA TELESCOPE EN NEOVIM 0.11 ---
local status_ok, telescope = pcall(require, "telescope")
if status_ok then
  telescope.setup{
    defaults = {
      preview = {
        -- Esto es lo importante: desactivar treesitter en la vista previa
        -- para que no busque la función 'ft_to_lang' que ya no existe.
        treesitter = false
      }
    }
  }
end

