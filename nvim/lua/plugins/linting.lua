return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>ll",
			function()
				local lint = require("lint")
				lint.try_lint()
			end,
			mode = "n",
			desc = "Try lint file",
		},
	},
	config = function()
		local lint = require("lint")

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		local getSharedLinter = function(default)
			default = default or { "biomejs", "eslint_d" }
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
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				"eslint.config.ts",
				"eslint.config.mts",
				"eslint.config.cts",
				".eslintrc.json",
			}, {
				upward = true,
				stop = git_root .. "/..",
			})

			if #config_file > 0 then
				return { "eslint_d" }
			end
			return default
		end

		local sharedLinter = getSharedLinter()

		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			group = lint_augroup,
			callback = function()
				sharedLinter = getSharedLinter()
				lint.linters_by_ft = {
					javascript = sharedLinter,
					typescript = sharedLinter,
					javascriptreact = sharedLinter,
					typescriptreact = sharedLinter,
					json = { "biomejs" },
					jsonc = { "biomejs" },
					python = { "pylint" },
					lua = { "luacheck" },
				}
			end,
		})

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		lint.linters_by_ft = {
			javascript = sharedLinter,
			typescript = sharedLinter,
			javascriptreact = sharedLinter,
			typescriptreact = sharedLinter,
			json = { "biomejs" },
			jsonc = { "biomejs" },
			python = { "pylint" },
			lua = { "luacheck" },
		}

		lint.linters.luacheck = {
			cmd = "luacheck",
			stdin = true,
			args = {
				"--globals",
				"vim",
				"--",
			},
			stream = "stdout",
			ignore_exitcode = true,
			parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
				source = "luacheck",
			}),
		}
	end,
}
