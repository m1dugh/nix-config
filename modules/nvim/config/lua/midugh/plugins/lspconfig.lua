return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "mason-org/mason-lspconfig.nvim",
    },

    config = function()

        vim.lsp.config("clangd", {
            settings = {
                cmd = "clangd",
            },
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            'vim',
                            'require',
                        },
                    },
                },
            },
        })


        -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(event)
                local opts = { buffer = event.buf }
                vim.bo[event.buf].omnifunc = nil
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
                vim.keymap.set('n', '<leader>qf', vim.lsp.buf.code_action, opts)
            end
        })

        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            { border = 'rounded' }
        )

        vim.diagnostic.config({
            float = {
                border = 'rounded',
                source = 'always',
            }
        })
    end
}
