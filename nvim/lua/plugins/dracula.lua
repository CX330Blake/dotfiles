return {
    -- Theme
    { "Mofiqul/dracula.nvim", italic_comment = true },
    -- Configure LazyVim to load dracula
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "dracula",
        },
    },
}
