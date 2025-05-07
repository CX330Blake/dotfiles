-- Discipline
local discipline = require("cx330.discipline")
discipline.vampire()

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Insert mode keymaps

map("i", "jk", "<Esc>", { noremap = true, silent = true })
map("n", "<leader>zz", ":ZenMode<CR>", { noremap = true, silent = true })
