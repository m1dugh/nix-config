return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    { 'mfussenegger/nvim-dap' },
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
    },
    {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    },
}
