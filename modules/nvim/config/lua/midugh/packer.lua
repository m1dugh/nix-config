
vim.cmd [[packadd packer.nvim]]

local packer = require("packer")
packer.util = require("packer.util")

packer.startup({function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- use {
    --     'nvim-tree/nvim-tree.lua',
    --     as = "nvim-tree",
    -- }

    use 'mfussenegger/nvim-dap'

    use 'rebelot/kanagawa.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
    }

    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    }

end, config = {
    compile_path = packer.util.join_paths(vim.fn.stdpath("cache"), "plugin", "packer_compiled.lua")
}})
