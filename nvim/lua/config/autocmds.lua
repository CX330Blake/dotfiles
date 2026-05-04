-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.md", "*.txt", "*.wiki" },
    callback = function()
        if vim.fn.exists(":PanguAll") == 2 then
            vim.cmd("silent! PanguAll")
        end
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})

local snacks_dashboard_group = vim.api.nvim_create_augroup("open_snacks_dashboard_when_empty", { clear = true })
local is_exiting = false
local ignored_filetypes = {
    lazy = true,
    snacks_dashboard = true,
}

vim.api.nvim_create_autocmd("VimLeavePre", {
    group = snacks_dashboard_group,
    callback = function()
        is_exiting = true
    end,
})

local function is_real_buffer(buf)
    if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].buflisted then
        return false
    end

    local buftype = vim.bo[buf].buftype
    local filetype = vim.bo[buf].filetype
    local name = vim.api.nvim_buf_get_name(buf)

    if buftype ~= "" or ignored_filetypes[filetype] then
        return false
    end

    return name ~= "" or vim.bo[buf].modified
end

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = snacks_dashboard_group,
    callback = function(event)
        if not is_real_buffer(event.buf) then
            return
        end

        vim.defer_fn(function()
            if is_exiting then
                return
            end

            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if is_real_buffer(buf) then
                    return
                end
            end

            local win = vim.api.nvim_get_current_win()
            local buf = vim.api.nvim_get_current_buf()
            local win_config = vim.api.nvim_win_get_config(win)

            if win_config.relative ~= "" or vim.bo[buf].buftype ~= "" or ignored_filetypes[vim.bo[buf].filetype] then
                return
            end

            Snacks.dashboard.open({
                win = win,
                buf = buf,
            })
        end, 20)
    end,
})
