return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lspconfig = require("lspconfig")
		local keymap = vim.keymap

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem = {
			documentationFormat = { "markdown", "plaintext" },
			snippetSupport = true,
			preselectSupport = true,
			insertReplaceSupport = true,
			labelDetailsSupport = true,
			deprecatedSupport = true,
			commitCharactersSupport = true,
			tagSupport = { valueSet = { 1 } },
			resolveSupport = {
				properties = {
					"documentation",
					"detail",
					"additionalTextEdits",
				},
			},
		}

		local on_attach = function(_, bufnr)
			local function opts(desc)
				return { buffer = bufnr, desc = "LSP " .. desc }
			end

			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts("Show LSP references"))

			keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))

			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts("Show LSP definitions"))

			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts("Show LSP implementations"))

			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts("Show LSP type definitions"))

			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("See available code actions"))

			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Smart rename"))

			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts("Show buffer diagnostics"))

			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts("Show line diagnostics"))

			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Go to previous diagnostic"))

			keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Go to next diagnostic"))

			keymap.set("n", "K", vim.lsp.buf.hover, opts("Show documentation for what is under cursor"))

			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts("Restart LSP"))
		end

		local signs = { Error = "❌", Warn = "⚠️", Hint = "💡", Info = "ℹ️" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local servers = {
			"ts_ls",
			"tailwindcss",
			"pyright",
			"dockerls",
			"nginx_language_server",
			"sqlls",
			"terraformls",
			"ansiblels",
			"powershell_es",
		}
		for _, lsp in ipairs(servers) do
			lspconfig[lsp].setup(require("coq").lsp_ensure_capabilities({
				on_attach = on_attach,
				capabilities = capabilities,
			}))
		end
		lspconfig["biome"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = require("lspconfig.util").root_pattern(".git/", "."),
			cmd = { "biome", "lsp-proxy", "--config-path", vim.fn.expand("$HOME/.config/nvim") },
		})

		lspconfig["lua_ls"].setup(require("coq").lsp_ensure_capabilities({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		}))

		lspconfig["emmet_language_server"].setup(require("coq").lsp_ensure_capabilities({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "html", "typescriptreact", "javascriptreact" },
		}))

		lspconfig["cssls"].setup(require("coq").lsp_ensure_capabilities({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				css = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
				scss = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		}))

		lspconfig["taplo"].setup(require("coq").lsp_ensure_capabilities({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				taplo = {
					properties = {
						exclude = {},
					},
				},
			},
		}))
	end,
}
