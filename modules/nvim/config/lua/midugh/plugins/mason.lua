return {
    "mason-org/mason.nvim",
    dependencies = {
        "mason-org/mason-lspconfig.nvim",
    },

    config = function()
        require('mason').setup({
            ui = {
                border = 'rounded',
            }
        })

        require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = {
                'bashls',
                'nil_ls',
            },
        })
    end
}
