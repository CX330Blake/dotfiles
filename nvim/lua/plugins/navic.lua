return {
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = function()
            vim.g.navic_silence = true
        end,
        opts = function()
            Snacks.util.lsp.on({ method = "textDocument/documentSymbol" }, function(buffer, client)
                require("nvim-navic").attach(client, buffer)
            end)

            return {
                separator = " ",
                highlight = true,
                depth_limit = 5,
                icons = LazyVim.config.icons.kinds,
                lazy_update_context = true,
            }
        end,
    },
}
