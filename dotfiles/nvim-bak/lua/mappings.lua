require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- Disable default mappings
pcall(nomap, "n", "<tab>")
pcall(nomap, "n", "<S-tab>")
pcall(nomap, "n", "<C-n>")

-- rust-tools
map("n", "<C-space>", function()
  require("rust-tools.hover_actions").hover_actions()
end, { desc = "Rust hover actions" })

map("n", "<leader>a", function()
  require("rust-tools.code_action_group").code_action_group()
end, { desc = "Rust code action group" })

-- lazygit
map("n", "<leader>gg", "<cmd> LazyGit <CR>", { desc = "LazyGit" })

-- noice
map("n", "<leader>nl", "<cmd> Noice last <CR>", { desc = "Show last message" })
map("n", "<leader>nt", "<cmd> Noice telescope <CR>", { desc = "Noice telescope mode" })
map("n", "<leader>nd", "<cmd> Noice dismiss <CR>", { desc = "Dismiss messages" })
map("n", "<leader>ns", "<cmd> Noice stats <CR>", { desc = "Show Noice stats" })

-- worktree
map("n", "<leader>gwv", function()
  require("telescope").extensions.git_worktree.git_worktrees()
end, { desc = "View Git Worktrees" })

map("n", "<leader>gwn", function()
  require("telescope").extensions.git_worktree.create_git_worktree()
end, { desc = "New Git Worktree" })

-- general
map("n", "<C-q>", "<cmd> wq <CR>", { desc = "Save and exit" })
map("n", "<leader>q", "<cmd> wq <CR>", { desc = "Save and exit" })

-- trouble
map("n", "<leader>tt", "<cmd> Trouble diagnostics toggle <CR>", { desc = "Diagnostics (Trouble)" })

-- tabufline
map("n", "<S-h>", function()
  require("nvchad.tabufline").tabuflinePrev()
end, { desc = "Goto prev buffer" })

map("n", "<S-l>", function()
  require("nvchad.tabufline").tabuflineNext()
end, { desc = "Goto next buffer" })

-- nvimtree
map("n", "<leader>e", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree" })

-- lazydocker
map("n", "<leader>ld", "<cmd> LazyDocker <CR>", { desc = "Lazy Docker" })

-- cloak
map("n", "<leader>k", "<cmd> CloakToggle <CR>", { desc = "Toggle Cloak" })
