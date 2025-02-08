return {
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>ue",
                function()
                    require("edgy").toggle()
                end,
                desc = "Edgy Toggle",
            },
    -- stylua: ignore
            { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
        },
        opts = function()
            local opts = {
                animate = {
                    enabled = true,
                    fps = 100, -- frames per second
                    cps = 120, -- cells per second
                    on_begin = function()
                        vim.g.minianimate_disable = true
                    end,
                    on_end = function()
                        vim.g.minianimate_disable = false
                    end,
                    -- Spinner for pinned views that are loading.
                    -- if you have noice.nvim installed, you can use any spinner from it, like:
                    -- spinner = require("noice.util.spinners").spinners.circleFull,
                    spinner = {
                        frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                        interval = 80,
                    },
                },
                bottom = {
                    {
                        ft = "toggleterm",
                        size = { height = 0.4 },
                        filter = function(buf, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                        end,
                    },
                    {
                        ft = "noice",
                        size = { height = 0.4 },
                        filter = function(buf, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                        end,
                    },
                    "Trouble",
                    { ft = "qf", title = "QuickFix" },
                    {
                        ft = "help",
                        size = { height = 20 },
                        -- don't open help files in edgy that we're editing
                        filter = function(buf)
                            return vim.bo[buf].buftype == "help"
                        end,
                    },
                    { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
                    { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
                },
                left = {
                    {
                        title = "Outline",
                        ft = "Outline",
                        pinned = true,
                        open = function()
                            vim.cmd("SymbolsOutline") -- 開啟 Outline
                        end,
                    },
                },
                right = {
                    { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
                },
                keys = {
                    -- increase width
                    ["<c-Right>"] = function(win)
                        win:resize("width", 2)
                    end,
                    -- decrease width
                    ["<c-Left>"] = function(win)
                        win:resize("width", -2)
                    end,
                    -- increase height
                    ["<c-Up>"] = function(win)
                        win:resize("height", 2)
                    end,
                    -- decrease height
                    ["<c-Down>"] = function(win)
                        win:resize("height", -2)
                    end,
                },
            }

            if LazyVim.has("neo-tree.nvim") then
                local pos = {
                    filesystem = "left",
                    buffers = "top",
                    git_status = "right",
                    document_symbols = "bottom",
                    diagnostics = "bottom",
                }
                local sources = LazyVim.opts("neo-tree.nvim").sources or {}
                for i, v in ipairs(sources) do
                    table.insert(opts.left, i, {
                        title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
                        ft = "neo-tree",
                        filter = function(buf)
                            return vim.b[buf].neo_tree_source == v
                        end,
                        pinned = true,
                        open = function()
                            vim.cmd(
                                ("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, LazyVim.root())
                            )
                        end,
                    })
                end
            end

            -- trouble
            for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
                opts[pos] = opts[pos] or {}
                table.insert(opts[pos], {
                    ft = "trouble",
                    filter = function(_buf, win)
                        return vim.w[win].trouble
                            and vim.w[win].trouble.position == pos
                            and vim.w[win].trouble.type == "split"
                            and vim.w[win].trouble.relative == "editor"
                            and not vim.w[win].trouble_preview
                    end,
                })
            end

            -- snacks terminal
            for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
                opts[pos] = opts[pos] or {}
                table.insert(opts[pos], {
                    ft = "snacks_terminal",
                    size = { height = 0.4 },
                    title = "%{b:snacks_terminal.id}: %{b:term_title}",
                    filter = function(_buf, win)
                        return vim.w[win].snacks_win
                            and vim.w[win].snacks_win.position == pos
                            and vim.w[win].snacks_win.relative == "editor"
                            and not vim.w[win].trouble_preview
                    end,
                })
            end
            return opts
        end,
    },
}
