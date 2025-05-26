return {

    -- Catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            transparent_background = true,
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
                transparent_bg = true,
            })
        end,
    },
    -- Configure LazyVim to load dracula
    {
        "LazyVim/LazyVim",
        opts = {
            -- colorscheme = "catppuccin-mocha",
            colorscheme = "tokyonight-storm",
            -- colorscheme = "tokyonight",
            -- colorscheme = "tokyonight-night"
            -- colorscheme = "tokyonight-storm"
            -- colorscheme = "tokyonight-day",
            -- colorscheme = "tokyonight-moon",
        },
    },
}
