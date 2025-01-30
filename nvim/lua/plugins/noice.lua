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
                    max_width = 60,
                    render = "wrapped-default",
                },
            },
        },
        opts = {
            cmdline = {
                enabled = true,
                view = "cmdline_popup",
                opts = {},
                format = {
                    -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
                    -- view: (default is cmdline view)
                    -- opts: any options passed to the view
                    -- icon_hl_group: optional hl_group for the icon
                    -- title: set to anything or empty string to hide
                    cmdline = { pattern = "^:", icon = "", lang = "vim" },
                    search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                    search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
                    filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                    lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                    help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
                    input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
                    -- lua = false, -- to disable a format, set to `false`
                },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = "50%", -- 垂直居中
                        col = "50%", -- 水平居中
                    },
                    size = {
                        min_width = 60,
                        width = "auto", -- 設置寬度
                        height = "auto", -- 高度自適應
                    },
                    border = {
                        style = "rounded", -- 圓角邊框
                        text = {
                            top = " Command ", -- 邊框上方的標題
                        },
                    },
                },
                confirm = {
                    position = {
                        row = "50%", -- 縮小選單，使其位於螢幕中央
                        col = "50%", -- 水平居中
                    },
                    size = {
                        width = "auto", -- 限制選單寬度
                        height = "auto", -- 讓高度自適應內容
                    },
                    border = {
                        style = "rounded", -- 使用圓角邊框
                        text = {
                            top = " Confirm ", -- 標題
                        },
                    },
                    win_options = {
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
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
