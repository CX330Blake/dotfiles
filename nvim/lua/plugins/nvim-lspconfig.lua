return {
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            opts.servers = opts.servers or {}

            opts.servers.pyright = vim.tbl_deep_extend("force", opts.servers.pyright or {}, {
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                        },
                    },
                },
            })

            opts.servers.ruff = vim.tbl_deep_extend("force", opts.servers.ruff or {}, {
                on_attach = function(client, _)
                    -- Let Pyright handle hover for Python symbols.
                    client.server_capabilities.hoverProvider = false
                end,
            })
        end,
    },
}
