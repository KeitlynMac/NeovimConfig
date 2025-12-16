--- BUSCADOR DE CARPETAS PERSONALIZADO ---

-- Definimos una funcion global para usarla en el Dashboard
_G.buscar_y_entrar = function()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local builtin = require('telescope.builtin')

  builtin.find_files({
    prompt_title = "📂 Navegar a Carpeta",
    -- Usamos 'find' para buscar SOLO directorios (-type d) y ocultar los ocultos
    find_command = { "find", ".", "-type", "d", "-not", "-path", "*/.*" },
    previewer = false, -- Desactivamos la vista previa para que sea mas rapido
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
            local dir = selection[1]
            -- Comandos magicos: Entrar, Cerrar Arbol viejo, Abrir Arbol nuevo
            vim.cmd('cd ' .. dir)
            vim.cmd('NvimTreeClose')
            vim.cmd('NvimTreeOpen')
            print("Carpeta: " .. dir)
        end
      end)
      return true
    end
  })
end

