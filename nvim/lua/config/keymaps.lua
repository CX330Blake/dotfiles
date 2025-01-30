-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Insert mode keymaps

map("i", "jk", "<Esc>", { noremap = true, silent = true })

-- LazyGit

if vim.fn.executable("lazygit") == 1 then
    map("n", "<leader>gg", function()
        Snacks.lazygit({ cwd = vim.fn.expand("%:p:h") })
    end, { desc = "Lazygit (Current File Dir)" })
    map("n", "<leader>gG", function()
        Snacks.lazygit()
    end, { desc = "Lazygit (cwd)" })
    map("n", "<leader>gf", function()
        Snacks.picker.git_log_file()
    end, { desc = "Git Current File History" })
    map("n", "<leader>gl", function()
        Snacks.picker.git_log({ cwd = LazyVim.root.git() })
    end, { desc = "Git Log" })
    map("n", "<leader>gL", function()
        Snacks.picker.git_log()
    end, { desc = "Git Log (cwd)" })
end
