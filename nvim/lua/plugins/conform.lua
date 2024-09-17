return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>fp",
			function()
				require("conform").format({
					async = true,
				})
			end,
			mode = { "n", "v" },
			desc = "Format file or range (in visual mode)",
		},
	},
	opts = function()
		local getSharedFormatter = function(default)
			default = default or { "biome" }
			local exec = function(command)
				local f = io.popen(command)

				if f ~= nil then
					local l = f:read()

					f:close()
					return l
				end
			end

			local git_root = exec("git rev-parse --show-toplevel")
			if git_root == nil then
				return default
			end

			local config_file = vim.fs.find({
				".prettierrc",
				".prettierrc.json",
				".prettierrc.yml",
				".prettierrc.yaml",
				".prettierrc.json5",
				".prettierrc.js",
				".prettierrc.cjs",
				".prettierrc.mjs",
				".prettierrc.toml",
				"prettier.config.js",
				"prettier.config.cjs",
				"prettier.config.mjs",
			}, {
				upward = true,
				stop = git_root .. "/..",
			})

			if #config_file > 0 then
				return { { "prettierd", "prettier" } }
			end
			return default
		end
		return {
			default_format_opts = {
				lsp_format = false,
				async = false,
				timeout_ms = 1000,
			},
			formatters_by_ft = {
				css = getSharedFormatter({ "biome", "prettierd" }),
				scss = getSharedFormatter({ "biome", "prettierd" }),
				html = getSharedFormatter({ "biome", "prettierd" }),
				javascript = getSharedFormatter(),
				javascriptreact = getSharedFormatter(),
				typescript = getSharedFormatter(),
				typescriptreact = getSharedFormatter(),
				lua = { "stylua" },
				json = getSharedFormatter(),
				jsonc = getSharedFormatter(),
				yaml = { "prettierd" },
				toml = { "taplo" },
				sh = { "beautysh" },
			},
			notify_on_error = true,
			format_on_save = {},
			formatters = {
				biome = {
					inherit = true,
					append_args = { "--config-path", vim.fn.expand("$HOME/.config/nvim") },
				},
			},
		}
	end,
}
