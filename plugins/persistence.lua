require("persistence").setup()

-- Atajo para restaurar la sesión
vim.keymap.set("n", "<space>qs", [[<cmd>lua require("persistence").load()<cr>]], { desc = "Restaurar Sesión" })
