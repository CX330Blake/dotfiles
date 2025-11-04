return {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
        require("themery").setup({
            -- Minimal config
            themes = {
                "catppuccin-latte",
                "rose-pine",
                "tokyonight-moon",
                "dracula",
                "catppuccin-mocha",
                "gruvbox",
            }, -- Your list of installed colorschemes.
            livePreview = true, -- Apply theme while picking. Default to true.
        })
    end,
}
