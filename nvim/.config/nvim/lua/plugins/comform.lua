return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                json = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                cpp = { "clang-format" },
                c = { "clang-format" },
                yaml = { "prettier" },
                terraform = { "terraform_fmt" },
            },
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 1000,
            },
        })
    end
}
