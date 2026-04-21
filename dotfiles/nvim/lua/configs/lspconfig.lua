local nvlsp = require "nvchad.configs.lspconfig"

-- remove <leader>q from LSP mappings (user override for save+quit)
local orig_on_attach = nvlsp.on_attach
nvlsp.on_attach = function(client, bufnr)
  orig_on_attach(client, bufnr)
  pcall(vim.keymap.del, "n", "<leader>q", { buffer = bufnr })
end

nvlsp.defaults()

local custom_on_attach = function(client, bufnr)
  nvlsp.on_attach(client, bufnr)

  if client.name == "ts_ls" then
    vim.api.nvim_buf_create_user_command(bufnr, "OrganizeImports", function()
      vim.lsp.buf.execute_command {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
      }
    end, { desc = "Organize Imports" })
  end
end

vim.lsp.config("ts_ls", {
  on_attach = custom_on_attach,
  capabilities = nvlsp.capabilities,
  init_options = {
    preferences = {
      disablesuggestions = true,
    },
  },
})
vim.lsp.enable "ts_ls"

vim.lsp.config("terraformls", {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
})
vim.lsp.enable "terraformls"

vim.lsp.config("tflint", {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
})
vim.lsp.enable "tflint"

vim.lsp.config("gopls", {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotempl" },
  root_markers = { "go.mod", "go.work" },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})
vim.lsp.enable "gopls"

vim.lsp.config("pyright", {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  filetypes = { "python" },
})
vim.lsp.enable "pyright"

vim.lsp.config("nil_ls", {
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  cmd = { "nil" },
  filetypes = { "nix" },
  settings = {
    ["nil"] = {
      testSetting = 42,
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})
vim.lsp.enable "nil_ls"
