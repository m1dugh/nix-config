local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
    'rust_analyzer',
    'gopls',
    'clangd'
})

local cmp = require('cmp')
local cmp_select = {behaviour = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    [ '<C-p>' ] = cmp.mapping.select_prev_item(cmp_select),
    [ '<C-n>' ] = cmp.mapping.select_next_item(cmp_select),
    [ '<C-y>' ] = cmp.mapping.confirm({ select = true }),
    [ '<C-Space>' ] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
end)

lsp.setup()
