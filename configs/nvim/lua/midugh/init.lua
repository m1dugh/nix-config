
local set = vim.opt

set.tabstop = 4
set.shiftwidth = 4
set.expandtab = true
set.number = true
set.relativenumber = true
set.cc = "80"
set.signcolumn = "yes"
set.ignorecase = true
set.smartcase = true
set.autoread = true

vim.keymap.set("n", "+", function () vim.cmd("m -2") end)
vim.keymap.set("n", "-", function () vim.cmd("m +1") end)
