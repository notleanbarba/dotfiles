local set = vim.opt
local g = vim.g
local wo = vim.wo
local o = vim.o

g.mapleader = "\\"
g.maplocalleader = "\\"

wo.number = true
wo.relativenumber = true
wo.foldmethod = "expr"
wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
wo.foldlevel = 5
o.foldtext = ""
o.fillchars = "fold:-"

set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.cmdheight = 1

require("config.lazy")
vim.cmd("colorscheme kanagawa-wave")

vim.diagnostic.config({ float = {
	source = true,
} })

vim.keymap.set("n", "<Tab>", "za")

vim.o.clipboard = "unnamedplus"
--Copy to global clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+yg_')
vim.keymap.set("n", "<leader>Y", '"+yg_')
vim.keymap.set("n", "<leader>yy", '"+yy')
--Paste from global clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')
