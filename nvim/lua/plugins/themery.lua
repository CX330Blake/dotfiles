return {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
        require("themery").setup({
            -- Minimal config
            themes = {
                "dracula",
                "rose-pine",
                "tokyonight-moon",
                "catppuccin-latte",
                "catppuccin-mocha",
                "gruvbox",
            }, -- Your list of installed colorschemes.
            livePreview = true, -- Apply theme while picking. Default to true.
        })
    end,
}
