-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

map({ "n", "t" }, "<M-v>", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Toggle Terminal Vertical Split" })

map({ "n", "t" }, "<M-h>", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Toggle Terminal Horizontal Split" })
