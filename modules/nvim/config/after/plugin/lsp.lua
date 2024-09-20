local cmp = require('cmp')

local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function (args)
            luasnip.lsp_expand(args.body)
        end
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({select = true}),
    })
})

require('mason').setup({
    ui = {
        border = 'rounded',
    }
})


require('mason-lspconfig').setup({
    ensure_installed = {
        'bashls',
        'nil_ls',
    }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
}

local servers = {
    clangd = {
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
        filetypes = {
            "rust"
        },
        cmd = {
            "rust-analyzer",
        },
    },

    slint_lsp = {
        filetypes = {
            "slint",
        },
        cmd = {
            "slint-lsp"
        },
    },
}

local function setup_lsp_server(server_name, config)
    config.handlers = handlers;
    config.capabilities = capabilities;
    lspconfig[server_name].setup(config)
end

require('mason-lspconfig').setup_handlers({
    function (server_name)
        local server_config = servers[server_name] or {
            on_attach = function()
            end,
        }
        setup_lsp_server(server_name, server_config)
    end
})

for server_name, config in pairs(servers) do
    setup_lsp_server(server_name, config)
end

local function lsp_settings()
    vim.diagnostic.config({
        float = {
            source = "always",
            border = "rounded",
        },
        virtual_text = true,
        signs = true,
    })

end

lsp_settings()

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.bo[event.buf].omnifunc = nil
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', function(opts) vim.lsp.buf.hover() end, opts)
    end
})
