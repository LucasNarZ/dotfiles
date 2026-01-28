return {
	"kyazdani42/nvim-tree.lua",
	config = function()
		require("nvim-tree").setup({
			filters = {
				git_ignored = false
			},
            view = {
                width = 60,
            },

		})
	end,
}
