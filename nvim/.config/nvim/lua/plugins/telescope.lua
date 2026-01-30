return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    file_ignore_patterns = {
                        "node_modules/",
                        ".git/",
                        "dist/",
                        "build/",
                        "%.lock",
                        "yarn%.cache/",
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden" }
                        end,
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            telescope.load_extension("fzf")
        end,
    },
}
