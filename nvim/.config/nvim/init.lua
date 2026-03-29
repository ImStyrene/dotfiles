vim.g.mapleader = " "
vim.cmd.colorscheme("tokyonight-moon")
vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]])
vim.cmd([[hi NormalFloat guibg=NONE ctermbg=NONE]])
vim.cmd([[hi FloatBorder guibg=NONE ctermbg=NONE]])

require('remaps')
require('settings')
require('config.packer')
