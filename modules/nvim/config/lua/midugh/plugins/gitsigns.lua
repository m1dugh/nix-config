return {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	opts = {
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local opts = {
				buffer = bufnr,
			}

			vim.keymap.set("n", "<leader>gb", gitsigns.blame, opts)
			vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, opts)
		end,
	},
}
