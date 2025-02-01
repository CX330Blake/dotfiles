return {
    -- Theme
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
        },
    },
}
