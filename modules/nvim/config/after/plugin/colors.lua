local kanagawa = require("kanagawa")

kanagawa.setup({
    theme = "dragon",
    background = {
        light = "lotus",
        dark = "dragon",
    },
})

vim.cmd('colorscheme kanagawa')
