local config = require "plugins.configs.lspconfig"
local on_attach = config.on_attach
local capabilities = config.capabilities

local custom_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  if client.name == "ts_ls" then
    vim.api.nvim_buf_create_user_command(bufnr, "OrganizeImports", function()
      local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
      }
      client:request("workspace/executeCommand", params)
    end, { desc = "Organize Imports" })
  end
end

vim.lsp.config("ts_ls", {
  on_attach = custom_on_attach,
  capabilities = capabilities,
  init_options = {
    preferences = {
      disablesuggestions = true,
    },
  },
})
vim.lsp.enable "ts_ls"

vim.lsp.config("terraformls", {
  on_attach = on_attach,
  capabilities = capabilities,
})
vim.lsp.enable "terraformls"

vim.lsp.config("tflint", {
  on_attach = on_attach,
  capabilities = capabilities,
})
vim.lsp.enable "tflint"

vim.lsp.config("gopls", {
  on_attach = on_attach,
  capabilities = capabilities,
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
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
})
vim.lsp.enable "pyright"

vim.lsp.config("nil_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
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
