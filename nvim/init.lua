-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Font
vim.api.nvim_set_hl(0, "Comment", { italic = true })
