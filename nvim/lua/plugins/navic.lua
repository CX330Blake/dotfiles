return {
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = function()
            vim.g.navic_silence = true
            LazyVim.lsp.on_attach(function(client, buffer)
                if client.supports_method("textDocument/documentSymbol") then
                    require("nvim-navic").attach(client, buffer)
                end
            end)
        end,
        opts = function()
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
