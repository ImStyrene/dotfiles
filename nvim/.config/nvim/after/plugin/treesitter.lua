require('nvim-treesitter.configs').setup {
	ensure_installed = { 
		"c",
		"luau",
		"javascript",
		"typescript",
		"rust",
		"lua",
		"query",
		"markdown",
		"markdown_inline",
	},

	auto_install = true,

	highlight = {
		enable = true,
	
		disable = {
      -- Lorem Ipsum
    },
	},
}
