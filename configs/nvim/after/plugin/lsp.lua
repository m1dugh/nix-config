require('mason').setup({
    ui = {
        border = 'rounded',
    }
})


require('mason-lspconfig').setup({
    ensure_installed = {
        'bashls',
    }
})

local lspconfig = require('lspconfig')

local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
}

local servers = {
    clangd = {
        handlers = handlers,
        cmd = {
            "clangd",
            "--log=info",
        },
        filetypes = {
            "c",
            "cpp",
            "hpp",
            "h",
            "cc",
        },
    },

    rust_analyzer = {
        handlers = handlers,
        filetypes = {
            "rust"
        },
        cmd = {
            "rust-analyzer",
        },
    },
}

require('mason-lspconfig').setup_handlers({
    function (server_name)
        lspconfig[server_name].setup(servers[server_name] or {
            handlers = handlers,
            on_attach = function()
            end,
        })
    end
})

for server_name, config in pairs(servers) do
    lspconfig[server_name].setup(config)
end

vim.api.nvim_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
vim.o.completeopt = "longest,menuone,noselect"
vim.keymap.set('i', '<C-space>', '<C-x><C-o>')

local function lsp_settings()
    vim.diagnostic.config({
        float = {
            source = "always",
            border = "rounded",
        },
        virtual_text = true,
        signs = true,
    })

    --[[ vim.api.nvim_create_autocmd('CursorHold,CursorHoldI', {
        callback = function(event)
            vim.diagnostic.open_float(nil, {
                focus = false,
            })
        end
    }) ]]--

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
