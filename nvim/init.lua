-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Font
-- vim.api.nvim_set_hl(0, "Comment", { font = "VictorMono Nerd Font", italic = true })
-- vim.api.nvim_set_hl(0, "Normal", { font = "FiraCode Nerd Font" })

-- Cursor line
vim.opt.cursorline = false
