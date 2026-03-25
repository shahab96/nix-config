local M = {}

M.disabled = {
  n = {
    ["<tab>"] = "",
    ["<S-tab>"] = "",
    ["<C-n>"] = "",
  },
}

M["rust-tools"] = {
  n = {
    ["<C-space>"] = {
      function()
        require("rust-tools.hover_actions").hover_actions()
      end,
      "Rust hover actions",
    },
    ["<leader>a"] = {
      function()
        require("rust-tools.code_action_group").code_action_group()
      end,
      "Rust code action group",
    },
  },
}

M.lazygit = {
  n = {
    ["<leader>gg"] = {
      "<cmd> LazyGit <CR>",
      "LazyGit",
    },
  },
}

M.noice = {
  n = {
    ["<leader>nl"] = {
      "<cmd> Noice last <CR>",
      "Show last message",
    },
    ["<leader>nt"] = {
      "<cmd> Noice telescope <CR>",
      "Noice telescope mode",
    },
    ["<leader>nd"] = {
      "<cmd> Noice dismiss <CR>",
      "Dismiss messages",
    },
    ["<leader>ns"] = {
      "<cmd> Noice stats <CR>",
      "Show Noice stats",
    },
  },
}

M.worktree = {
  n = {
    ["<leader>gwv"] = {
      function()
        local telescope = require "telescope"
        telescope.extensions.git_worktree.git_worktrees()
      end,
      "View Git Worktrees",
    },
    ["<leader>gwn"] = {
      function()
        local telescope = require "telescope"
        telescope.extensions.git_worktree.create_git_worktree()
      end,
      "New Git Worktree",
    },
  },
}

M.general = {
  n = {
    ["<C-q>"] = {
      "<cmd> wq <CR>",
      "Save and exit",
    },
    ["<leader>q"] = {
      "<cmd> wq <CR>",
      "Save and exit",
    },
  },
}

M.trouble = {
  n = {
    ["<leader>tt"] = {
      "<cmd> Trouble diagnostics toggle <CR>",
      "Diagnostics (Trouble)",
    },
  },
}

M.tabufline = {
  n = {
    ["<S-h>"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },
    ["<S-l>"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },
  },
}

M.nvimtree = {
  n = {
    ["<leader>e"] = {
      "<cmd> NvimTreeToggle <CR>",
      "Toggle nvimtree",
    },
  },
}

M.lazydocker = {
  n = {
    ["<leader>ld"] = {
      "<cmd> LazyDocker <CR>",
      "Lazy Docker",
    },
  },
}

M.cloak = {
  n = {
    ["<leader>k"] = {
      "<cmd> CloakToggle <CR>",
      "Toggle Cloak",
    },
  },
}

return M
