return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "ts_ls", "pyright", "html", "tailwindcss", "prettier" }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local nvim_lsp = require("lspconfig")

            local on_attach = function(client, bufnr)
                local buf_map = function(mode, lhs, rhs)
                    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
                end

                buf_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
                buf_map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
                buf_map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
            end

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            nvim_lsp.ts_ls.setup {
                on_attach = on_attach,
                flags = {
                    debounce_text_changes = 150,
                },
                capabilities = capabilities
            }


            nvim_lsp.pyright.setup {
                on_attach = on_attach,
                flags = {
                    debounce_text_changes = 150,
                },
                capabilities = capabilities
            }
        end
    }
}
