return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        opts = {
            auto_install = true,
            ensure_installed = {
                "javascript",
                "lua",
                "python",
                "c",
                "cpp",
                "go",
                "rust",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
}
