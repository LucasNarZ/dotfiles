return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end)

        vim.keymap.set("n", "<leader>h", function()
            harpoon.ui:toggle_quick_menu(harpoon:list(), {
                border = "rounded",
                title_pos = "center",
                ui_width_ratio = 0.55,
            })

            vim.schedule(function()
                vim.keymap.set("n", "o", "<CR>", {
                    buffer = true,
                    silent = true,
                    remap = true,
                })
            end)
        end)

        vim.keymap.set("n", "<leader>1", function()
            harpoon:list():select(1)
        end)

        vim.keymap.set("n", "<leader>2", function()
            harpoon:list():select(2)
        end)

        vim.keymap.set("n", "<leader>3", function()
            harpoon:list():select(3)
        end)

        vim.keymap.set("n", "<leader>4", function()
            harpoon:list():select(4)
        end)

        vim.keymap.set("n", "<leader>5", function()
            harpoon:list():select(5)
        end)
    end,
}
