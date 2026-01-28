-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

local opts = { noremap = true, silent = true }

-- ToggleTerm
vim.keymap.set('t', '<C-x>', '<C-\\><C-n><Cmd>ToggleTerm<CR>', opts)

-- Move lines using Alt
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

vim.keymap.set("n", "<leader>yG", '"+yG', opts);
vim.keymap.set("n", "<leader>y", '"+y', opts);
vim.keymap.set("n", "<leader>Y", '"+yy', opts);
vim.keymap.set("v", "<leader>y", '"+y', opts);

-- Harpoon
vim.keymap.set("n", "<leader>a", function() require("harpoon.mark").add_file() end)
vim.keymap.set("n", "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end)
vim.keymap.set("n", "<leader>1", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() require("harpoon.ui").nav_file(4) end)
vim.keymap.set("n", "<leader>5", function() require("harpoon.ui").nav_file(5) end)


local treeApi = require('nvim-tree.api')
local view = require('nvim-tree.view')

local function get_width()
    if view.is_visible() then
        return vim.api.nvim_win_get_width(view.get_winnr())
    end
    return 0
end

vim.keymap.set('n', '<leader>+', function()
    local width = get_width()
    treeApi.tree.resize({ width = width + 5 })
end)

vim.keymap.set('n', '<leader>-', function()
    local width = get_width()
    treeApi.tree.resize({ width = width - 5 })
end)

vim.keymap.set('n', '<leader>e', treeApi.tree.toggle)
vim.keymap.set('n', '<leader>o', treeApi.tree.open)
vim.keymap.set('n', '<leader>c', treeApi.tree.close)

-- Indent Format
vim.keymap.set("n", "<leader>=", "ggvG=", opts)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<Esc><Esc>", ":noh<CR>")


vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
