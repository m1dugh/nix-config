
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use {
        'L3MON4D3/LuaSnip',
        after = 'nvim-cmp',
    }

    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    use {
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
    }

    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    }

end)