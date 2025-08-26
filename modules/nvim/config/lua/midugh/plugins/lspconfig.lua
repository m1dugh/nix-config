return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            automatic_installation = true,
            ensure_installed = {
                'bashls',
                'nil_ls',
            },
        },

        dependencies = {
            { "neovim/nvim-lspconfig" },
        },

        config = function(_, opts)
            require("mason-lspconfig").setup(opts)

            vim.lsp.config("clangd", {
                settings = {
                    cmd = { "clangd" },
                    filetypes = {"c", "cpp"},
                    root_dir = vim.fs.root(0, {"compile_commands.json", "compile_flags.txt", ".git"}),
                },
            })

            vim.lsp.enable('clangd')

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

            vim.lsp.enable('lua_ls')


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
}
