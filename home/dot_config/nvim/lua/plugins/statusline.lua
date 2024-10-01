return {
	{
		"itchyny/lightline.vim",
		config = function()
			vim.g.lightline = {
				colorscheme = 'base16_default'
			}
		end,
		dependencies = {
			"felixjung/vim-base16-lightline",
		},
	},
	{
		"edkolev/tmuxline.vim",
		config = function()
			vim.g.tmuxline_powerline_separators = 0
			vim.g.tmuxline_theme = 'lightline'

			vim.g.tmuxline_preset = {
				a = '#S',
				win = {'#I', '#W'},
				cwin = {'#I', '#W', '#F'},
				z = '#H',
				options = {
					['status-justify'] = 'left'
				},
			}
		end,
		dependencies = {
			"itchyny/lightline.vim",
		},
	},
}
