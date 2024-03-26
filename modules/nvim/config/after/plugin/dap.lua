local dap = require('dap')

dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "-i", "dap" }
}

local gdb_config = {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
}

dap.configurations.c = {
    gdb_config,
}

dap.configurations.cpp = {
    gdb_config,
}
