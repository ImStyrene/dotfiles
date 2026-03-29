vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- # THEMES # --
  use 'folke/tokyonight.nvim'

  -- # PLUGINS # --
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'echasnovski/mini.snippets'
  use 'abeldekat/cmp-mini-snippets'
  use 'SirVer/ultisnips'
  use 'quangnguyen30192/cmp-nvim-ultisnips'
  use 'dcampos/nvim-snippy'
  use 'dcampos/cmp-snippy'
  use 'folke/which-key.nvim'
  use 'MunifTanjim/nui.nvim'
  use 'nvim-tree/nvim-web-devicons'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'windwp/nvim-autopairs'
  use "ibhagwan/fzf-lua"
  use "echasnovski/mini.pick"
  use 'sindrets/diffview.nvim'
  use 'goolord/alpha-nvim'
  use 'ThePrimeagen/vim-be-good'
  use 'nvim-lualine/lualine.nvim '
  use {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
      "echasnovski/mini.pick",
    },
  }

  use ({
    'nvim-neo-tree/neo-tree.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    }
  })
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- # MY PLUGINS # --
  use {
    'ImStyrene/packer-gui',
    config = function()
      require("packer-gui")
    end
  }

end)
