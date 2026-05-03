return {
    {
        "nvim-treesitter/nvim-treesitter",
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
