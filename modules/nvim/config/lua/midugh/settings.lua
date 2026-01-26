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
set.updatetime = 1000
set.mouse = ""

vim.keymap.set("n", "+", function()
	vim.cmd("m -2")
end)
vim.keymap.set("n", "-", function()
	vim.cmd("m +1")
end)
vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-n><C-x>"
	else
		return "<CR>"
	end
end, { silent = true, expr = true })

vim.g.health = {
	style = "float",
}

vim.g.copilot_enable = false
