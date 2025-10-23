return {

    -- Catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            transparent_background = false,
            custom_highlights = function(colors)
                return {
                    LineNr = { fg = colors.overlay1 },
                    ["@punctuation.bracket"] = { fg = colors.text },
                    LspInlayHint = { fg = colors.overlay2 },
                }
            end,
        },
    },

    -- Cyberdream
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
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
            sidebars = {
                "Neotree",
                "Edgy",
            },
            on_highlights = function(hl, colors)
                local gray = "#6272A4"
                hl.LineNr = {
                    fg = gray,
                }
                hl.LineNrAbove = {
                    fg = gray,
                }
                hl.LineNrBelow = {
                    fg = gray,
                }
                hl.Comment = {
                    fg = gray,
                    italic = true,
                }
            end,
        },
    },
    -- Dracula
    {
        -- "Mofiqul/dracula.nvim",
        "CX330Blake/dracula.nvim",
        config = function()
            require("dracula").setup({
                italic_comment = true,
                transparent_bg = false,
            })
        end,
    },

    -- Gruvbox
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        opts = {
            terminal_colors = true, -- add neovim terminal colors
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = false,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            inverse = true, -- invert background for search, diffs, statuslines and errors
            contrast = "", -- can be "hard", "soft" or empty string
            palette_overrides = {},
            overrides = {},
            dim_inactive = false,
            transparent_mode = false,
        },
    },
    -- Rose Pine
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end,
    },

    -- Configure LazyVim to load dracula
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin-latte",
            -- colorscheme = "tokyonight-moon",
            -- colorscheme = "tokyonight",
            -- colorscheme = "tokyonight-night"
            -- colorscheme = "tokyonight-storm"
            -- colorscheme = "tokyonight-day",
            -- colorscheme = "tokyonight-moon",
            -- colorscheme = "gruvbox",
        },
    },
}
