local status_ok, focal = pcall(require, "focal")
if not status_ok then
  return
end

focal.setup({
  -- El plugin hace todo automático, pero puedes ajustar cosas como el tamaño
  -- si los archivos son muy pesados para que tu compu no se trabe.
})
