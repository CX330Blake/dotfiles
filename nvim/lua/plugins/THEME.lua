return {
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
            },
        },
    },
    -- Dracula
    {
        "Mofiqul/dracula.nvim",
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
            colorscheme = "dracula",
            -- colorscheme = "tokyonight",
            -- colorscheme tokyonight-night
            -- colorscheme tokyonight-storm
            -- colorscheme tokyonight-day
            -- colorscheme tokyonight-moon
        },
    },
}
