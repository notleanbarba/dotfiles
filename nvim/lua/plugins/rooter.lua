return {
	"airblade/vim-rooter",
	config = function()
		vim.g.rooter_patterns = { "=nvim", ".git" }
	end,
}
