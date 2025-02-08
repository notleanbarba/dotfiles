return {
	"ms-jpq/coq_nvim",
	lazy = false,
	branch = "coq",
	dependencies = {
		{ "ms-jpq/coq.artifacts", branch = "artifacts" },
		{ "ms-jpq/coq.thirdparty", branch = "3p" },
	},
	init = function()
		local remap = vim.api.nvim_set_keymap
		local npairs = require("nvim-autopairs")

		vim.g.coq_settings = {
			xdg = true,
			keymap = { recommended = false, manual_complete = "<C-s>" },
			auto_start = "shut-up",
			clients = {
				lsp = {
					short_name = "LSP",
				},
				buffers = {
					short_name = "BUF",
				},
				snippets = {
					short_name = "SNIP",
				},
			},
			limits = {
				completion_manual_timeout = 2,
			},
		}

		-- these mappings are coq recommended mappings unrelated to nvim-autopairs
		remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
		remap("i", "<c-c>", [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
		remap("i", "<tab>", [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
		remap("i", "<s-tab>", [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

		-- skip it, if you use another global object
		_G.MUtils = {}

		MUtils.CR = function()
			if vim.fn.pumvisible() ~= 0 then
				if vim.fn.complete_info({ "selected" }).selected ~= -1 then
					return npairs.esc("<c-y>")
				else
					return npairs.esc("<c-e>") .. npairs.autopairs_cr()
				end
			else
				return npairs.autopairs_cr()
			end
		end
		remap("i", "<cr>", "v:lua.MUtils.CR()", { expr = true, noremap = true })

		MUtils.BS = function()
			if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
				return npairs.esc("<c-e>") .. npairs.autopairs_bs()
			else
				return npairs.autopairs_bs()
			end
		end
		remap("i", "<bs>", "v:lua.MUtils.BS()", { expr = true, noremap = true })
	end,
}
