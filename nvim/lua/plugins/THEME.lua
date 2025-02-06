return {
    -- Cyberdream
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1337,
        opts = {
            transparent = true,
            italic_comment = true,
        },
    },
    -- Tokyonight
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
                comments = { italic = true },
            },
        },
    },
    -- Dracula
    {
        "Mofiqul/dracula.nvim",
        -- "CX330Blake/dracula.nvim",
        config = function()
            require("dracula").setup({
                italic_comment = true,
                transparent_bg = true,
            })
        end,
    },
    -- Configure LazyVim to load dracula
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyonight-storm",
            -- colorscheme = "tokyonight",
            -- colorscheme tokyonight-night
            -- colorscheme tokyonight-storm
            -- colorscheme tokyonight-day
            -- colorscheme tokyonight-moon
        },
    },
}
