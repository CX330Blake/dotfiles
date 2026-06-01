return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            -- CodeCompanion internal options
            opts = {
                log_level = "DEBUG", -- or "TRACE"
            },
            interactions = {
                chat = {
                    adapter = "opencode",
                },
            },
            display = {
                chat = {
                    window = {
                        layout = "vertical",
                        width = 0.35,
                        full_height = true,
                    },
                },
            },
        },
        keys = {
            {
                "<C-.>",
                "<cmd>CodeCompanionChat Toggle<cr>",
                mode = { "n", "v" },
                desc = "Toggle CodeCompanion chat",
            },
        },
    },
}
