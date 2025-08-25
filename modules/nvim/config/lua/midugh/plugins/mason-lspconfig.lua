return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        automatic_installation = true,
        ensure_installed = {
            'bashls',
            'nil_ls',
        },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
