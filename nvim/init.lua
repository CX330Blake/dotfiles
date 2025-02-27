-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Clipboard
vim.defer_fn(function()
    vim.opt.clipboard:append("unnamedplus")
end, 100)

-- Cursor line
vim.opt.cursorline = false

-- Neovide config
if vim.g.neovide then
    vim.g.neovide_transparency = 0.75
    vim.g.transparency = 0.8
    vim.g.neovide_window_blurred = true
    vim.g.neovide_cursor_vfx_mode = "railgun"
end

-- Mac cmd to ctrl
if jit.os == "OSX" then
    vim.keymap.set({ "n", "i", "v", "c" }, "<M-c>", "<C-c>", { noremap = true, silent = true }) -- ⌘C -> Ctrl+C
    vim.keymap.set({ "n", "i", "v", "c" }, "<M-v>", "<C-v>", { noremap = true, silent = true }) -- ⌘V -> Ctrl+V
    vim.keymap.set({ "n", "i", "v", "c" }, "<M-x>", "<C-x>", { noremap = true, silent = true }) -- ⌘X -> Ctrl+X
end
