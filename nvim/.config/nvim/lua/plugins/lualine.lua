return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup()
    end,
    sections = {
        lualine_x = {
            function()
                local harpoon = require("harpoon.mark")
                local total = harpoon.get_length()
                local list = {}
                for i = 1, total do
                    table.insert(list, harpoon.get_marked_file_name(i))
                end
                return "📌 " .. table.concat(list, " | ")
            end
        }
    }
} 
