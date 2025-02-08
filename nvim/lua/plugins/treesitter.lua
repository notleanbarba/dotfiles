return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"javascript",
				"typescript",
				"css",
				"scss",
				"html",
				"json",
				"nginx",
				"python",
				"robots",
				"yaml",
				"sql",
				"terraform",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = false },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<BS>",
				},
			},
		})
	end,
}
