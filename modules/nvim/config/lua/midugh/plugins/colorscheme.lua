return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			theme = "dragon",
			background = {
				light = "lotus",
				dark = "dragon",
			},
		})
		vim.cmd("colorscheme kanagawa")
	end,
}
