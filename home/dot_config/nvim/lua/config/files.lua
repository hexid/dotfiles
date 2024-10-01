local generalSettingsGroup = vim.api.nvim_create_augroup("General settings", { clear = true })

vim.opt.expandtab = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"*.yaml",
		"*.js",
		"*.jsx",
		"*.ts",
		"*.tsx",
	},
	callback = function()
		vim.opt.expandtab = true
	end,
	group = generalSettingsGroup,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"*.py",
		"*.rs",
	},
	callback = function()
		vim.opt.expandtab = true
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4
		vim.opt.softtabstop = 4
	end,
	group = generalSettingsGroup,
})
