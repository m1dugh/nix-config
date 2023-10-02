--[[ require('mason').setup()


require('mason-lspconfig').setup({
    ensure_installed = {
        'rust_analyzer',
    }
}) --]]

local lspconfig = require('lspconfig')

lspconfig.clangd.setup({

    cmd = {
        "clangd",
        "--log=info",
    },
})

vim.api.nvim_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
vim.o.completeopt = "longest,menuone,noselect"
vim.keymap.set('i', '<C-space>', '<C-x><C-o>')

local function lsp_settings()
    vim .diagnostic.config({
        float = {
            border = 'rounded',
        }
    })
end

lsp_settings()

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(event)
        vim.api.nvim_buf_set_option(event.buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        local opts = { buffer = event.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', function(opts) vim.lsp.buf.hover() end, opts)
    end
})
