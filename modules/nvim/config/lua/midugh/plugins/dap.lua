return {
    "mfussenegger/nvim-dap",
    tag = "0.10.0",
    dependencies = {
        "mfussenegger/nvim-dap-python",
    },
    config = function()
        require('dap-python').setup('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
    end,
}
