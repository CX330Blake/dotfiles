return {
    {
        "levouh/tint.nvim",
        config = function()
            require("tint").setup({
                tint = -45, -- 讓背景變暗 (0 = 無變化, -100 = 完全黑)
                saturation = 0.6,
                highlight_ignore_patterns = { "WinSeparator", "StatusLine" },
                window_ignore_function = function(win_id)
                    return vim.api.nvim_win_get_config(win_id).relative ~= ""
                end,
            })
        end,
    },
}
