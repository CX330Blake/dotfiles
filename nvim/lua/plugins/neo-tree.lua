return {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = function(_, opts)
        -- 確保 open_files_do_not_replace_types 已初始化
        opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
            or { "terminal", "Trouble", "qf", "Outline", "trouble" }

        -- 避免 Neo-tree 替換 edgy 面板
        table.insert(opts.open_files_do_not_replace_types, "edgy")

        -- 禁用 Buffers 和 Git Status
        opts.sources = { "filesystem" } -- 只啟用 Filesystem，禁用 Buffers 和 Git

        -- 防止 Buffer 和 Git 狀態被打開（如果已加載）
        opts.source_selector = {
            winbar = false, -- 不在 winbar 顯示 source 切換器
            statusline = false, -- 不在 statusline 顯示
        }
    end,
}
