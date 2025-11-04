return {
    -- Catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        tag = "v1.10.0",
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
        priority = 1000,
        opts = {
            variant = "auto", -- auto, main, moon, or dawn
            dark_variant = "main", -- main, moon, or dawn
            dim_inactive_windows = false,
            extend_background_behind_borders = true,

            enable = {
                terminal = true,
                legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                migrations = true, -- Handle deprecated options automatically
            },

            styles = {
                bold = true,
                italic = true,
                transparency = false,
            },

            groups = {
                border = "muted",
                link = "iris",
                panel = "surface",

                error = "love",
                hint = "iris",
                info = "foam",
                note = "pine",
                todo = "rose",
                warn = "gold",

                git_add = "foam",
                git_change = "rose",
                git_delete = "love",
                git_dirty = "rose",
                git_ignore = "muted",
                git_merge = "iris",
                git_rename = "pine",
                git_stage = "iris",
                git_text = "rose",
                git_untracked = "subtle",

                h1 = "iris",
                h2 = "foam",
                h3 = "rose",
                h4 = "gold",
                h5 = "pine",
                h6 = "foam",
            },

            palette = {
                -- Override the builtin palette per variant
                -- moon = {
                --   base = "#18191a",
                --   overlay = "#363738",
                -- },
            },

            highlight_groups = {
                -- Comment = { fg = "foam" },
                -- StatusLine = { fg = "love", bg = "love", blend = 15 },
                -- VertSplit = { fg = "muted", bg = "muted" },
                -- Visual = { fg = "base", bg = "text", inherit = false },
            },

            before_highlight = function(group, highlight, palette)
                -- Disable all undercurls
                -- if highlight.undercurl then
                --   highlight.undercurl = false
                -- end
                --
                -- Change palette colour
                -- if highlight.fg == palette.pine then
                --   highlight.fg = palette.foam
                -- end
            end,
        },

        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd.colorscheme("rose-pine-dawn") -- 也可改成 "rose-pine-main"、"rose-pine-moon"、"rose-pine-dawn"
        end,
    },

    -- Configure LazyVim to load dracula
    {
        "LazyVim/LazyVim",
        opts = {
            -- colorscheme = "catppuccin-latte",
            colorscheme = "tokyonight-moon",
            -- colorscheme = "tokyonight",
            -- colorscheme = "tokyonight-night"
            -- colorscheme = "tokyonight-storm"
            -- colorscheme = "tokyonight-day",
            -- colorscheme = "tokyonight-moon",
            -- colorscheme = "gruvbox",
        },
    },
}
