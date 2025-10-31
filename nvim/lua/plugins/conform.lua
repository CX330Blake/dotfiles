return {
    "stevearc/conform.nvim",
    opts = {
        formatters = {
            prettier = {
                prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
            },
        },
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
            rust = { "rustfmt", lsp_format = "fallback" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
        },
    },
}
