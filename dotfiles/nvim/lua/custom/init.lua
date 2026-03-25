vim.g.maplocalleader = ","
vim.opt.colorcolumn = "80"
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-o>", 'copilot#Accept("<CR>")', { silent = true, expr = true, noremap = true, script = true })
vim.wo.relativenumber = true
vim.opt.scrolloff = 8

-- Auto-reload files when changed externally
vim.opt.autoread = true

-- Check for file changes when Neovim regains focus
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.cmd("checktime")
  end,
})

-- Notify when file has been changed externally
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})
