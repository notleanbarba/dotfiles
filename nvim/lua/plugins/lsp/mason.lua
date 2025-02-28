return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✔️",
					package_pending = "->",
					package_uninstalled = "❌",
				},
			},
		})
		mason_lspconfig.setup({
			ensure_installed = {
				"biome",
				"ts_ls",
				"lua_ls",
				"emmet_language_server",
				"tailwindcss",
				"cssls",
				"taplo",
				"pyright",
				"dockerls",
				"nginx_language_server",
				"sqlls",
				"terraformls",
				"ansiblels",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"biome",
				"stylua",
				"prettierd",
				"prettier",
				"eslint_d",
				"yamllint",
				"luacheck",
				"beautysh",
				"black",
				"pylint",
			},
		})
	end,
}
