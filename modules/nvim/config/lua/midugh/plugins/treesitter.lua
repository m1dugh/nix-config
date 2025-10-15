return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "lua", "nix", "terraform" },
			sync_install = true,
			auto_install = true,
			highlight = {
				enable = true,

				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
			autotag = {
				enable = true,
			},
		})

		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

		parser_config.tiger = {
			install_info = {
				url = "https://github.com/ambroisie/tree-sitter-tiger.git",
				files = {
					"src/scanner.c",
					"src/parser.c",
				},
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "tiger",
		}
	end,
}
