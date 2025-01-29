return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                "rcarriga/nvim-notify",
                opts = {
                    stages = "fade_in_slide_out",
                    timeout = 3000,
                    fps = 120,
                },
            },
        },
        opts = {
            views = {
                cmdline_popup = {
                    position = {
                        row = "50%", -- 垂直居中
                        col = "50%", -- 水平居中
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
            },
            presets = {
                bottom_search = false,
            },
            notify = {
                enabled = true, -- 讓 Noice 使用 nvim-notify
            },
        },
    },
}
