-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Cursor line
vim.opt.cursorline = false

-- Neovide config
if vim.g.neovide then
    vim.g.neovide_transparency = 0.75
    vim.g.transparency = 0.8
    vim.g.neovide_window_blurred = true
end
