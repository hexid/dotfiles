require("config.lazy")

vim.api.nvim_set_option_value("background", "dark", {})
--vim.api.nvim_set_option_value("t_Co", 256, {})

vim.g.base16_colorspace = 256

vim.cmd.colorscheme("base16-default-dark")

vim.wo.cursorline = true

vim.wo.list = true
vim.wo.number = true

require("config.files")
