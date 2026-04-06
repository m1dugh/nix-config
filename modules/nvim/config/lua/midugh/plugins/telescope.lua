return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.2.1",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		-- local previewers = require("telescope.previewers")

		require("telescope").setup({
			defaults = {
				layout_config = {
					horizontal = {
						preview_cutoff = 0,
					},
				},
			},
		})

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>pf", builtin.find_files, {})

		vim.keymap.set("n", "<C-p>", builtin.git_files, {})

		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({
				search = vim.fn.input("Grep > "),
			})
		end, {})
	end,
}
