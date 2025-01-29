return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
            views = {
                cmdline_popup = {
                    position = {
                        row = "50%", -- 垂直居中
                        col = "50%", -- 水平居中
                    },
                },
                size = {
                    width = 60, -- 設置寬度
                    height = "auto", -- 高度自適應
                },
                border = {
                    style = "rounded", -- 圓角邊框
                    text = {
                        top = " Command ", -- 邊框上方的標題
                    },
                },
            },
            presets = {
                bottom_search = false,
            },
            dependencies = {
                -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "MunifTanjim/nui.nvim",
                -- OPTIONAL:
                --   `nvim-notify` is only needed, if you want to use the notification view.
                --   If not available, we use `mini` as the fallback
                "rcarriga/nvim-notify",
            },
        },
    },
}
