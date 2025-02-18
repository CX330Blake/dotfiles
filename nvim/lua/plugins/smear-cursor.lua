return {
    -- Smear-cursor
    {
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
        cond = vim.g.neovide == nil and jit.os ~= "OSX",
        opts = {
            -- legacy_computing_symbols_support = true,
            stiffness = 0.6,
            trailing_stiffness = 0.3,
            distance_stop_animating = 0.1,
            -- transparent_bg_fallback_color = "#303030",
        },
        specs = {
            -- disable mini.animate cursor
            {
                "echasnovski/mini.animate",
                optional = true,
                opts = {
                    cursor = { enable = false },
                },
            },
        },
    },
}
