return {
    "stevearc/conform.nvim",
    opts = {
        formatters = {
            prettier = {
                prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
            },
        },
    },
}
