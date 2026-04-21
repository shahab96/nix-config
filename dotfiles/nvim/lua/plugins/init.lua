return {
  -- Formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
        "lua",
        "vim",
        "vimdoc",
      })
      return opts
    end,
  },

  -- lazydev
  { "folke/lazydev.nvim", ft = "lua", opts = {} },

  -- grpc-nvim
  {
    "hudclark/grpc-nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },

  -- git-worktree
  { "ThePrimeagen/git-worktree.nvim" },

  -- Telescope extension
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.extensions_list = opts.extensions_list or {}
      table.insert(opts.extensions_list, "git_worktree")
      return opts
    end,
  },

  -- noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
      messages = {
        enabled = false,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  -- trouble
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
        "rust-analyzer",
        "typescript-language-server",
        "prettier",
        "js-debug-adapter",
        "terraform-ls",
        "gopls",
        "pyright",
        "mypy",
        "ruff",
        "black",
        "lua-language-server",
        "nil",
        "phpactor",
      })
      return opts
    end,
  },

  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-o>",
        },
      },
      panel = { enabled = false },
    },
  },

  -- rust.vim
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  -- rust-tools
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
    opts = function()
      local nvlsp = require "nvchad.configs.lspconfig"
      return {
        server = {
          tools = {
            hover_actions = {
              auto_focus = true,
            },
          },
          on_attach = nvlsp.on_attach,
          capabilities = nvlsp.capabilities,
        },
      }
    end,
  },

  -- lazygit
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- lazydocker
  {
    "crnvl96/lazydocker.nvim",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },

  -- crates
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      local cmp = require "cmp"
      local sources = vim.deepcopy(cmp.get_config().sources or {})
      table.insert(sources, { name = "crates" })
      cmp.setup.buffer { sources = sources }
      crates.show()
    end,
  },

  -- cmp override
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.completion.completeopt = "menu,menuone,noselect"
      opts.mapping["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }
      table.insert(opts.sources, { name = "crates" })
      return opts
    end,
  },

  -- cloak
  {
    "laytan/cloak.nvim",
    lazy = false,
    opts = {
      enabled = true,
      cloak_character = "*",
      highlight_group = "Comment",
      patterns = {
        {
          file_pattern = {
            ".env*",
            "wrangler.toml",
            ".dev.vars",
          },
          cloak_pattern = "=.+",
        },
      },
    },
  },

  -- avante
  {
    "yetone/avante.nvim",
    build = vim.fn.has "win32" ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    version = false,
    opts = {
      instructions_file = "avante.md",
      provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        moonshot = {
          endpoint = "https://api.moonshot.ai/v1",
          model = "kimi-k2-0711-preview",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "stevearc/dressing.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
