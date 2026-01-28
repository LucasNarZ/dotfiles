return {
	"nvim-treesitter/nvim-treesitter",
	branch = 'master',
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			ensure_installed = {"typescript", "javascript", "python", "html", "css", "c", "bash", "markdown", "lua", "dockerts", "typescriptreact", "jsx"},
			sync_install = false,
			auto_install = true,
			indent = { enable = true },
		})
	end
}
