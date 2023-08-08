local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      -- We'll only use null-ls in case of lua, so that we use the better formatter: "stylua"
      -- Otherwise we just use the built-in formatter of the LSP
      local filetype = vim.api.nvim_buf_get_option(0, "filetype")
      if filetype == "lua" then
        return client.name == "null-ls"
      else
        return client.name ~= "null-ls"
      end
    end,
    bufnr = bufnr,
  })
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
  local bufmap = function(keys, func)
    vim.keymap.set("n", keys, func, { buffer = bufnr })
  end

  bufmap("<leader>r", vim.lsp.buf.rename)
  bufmap("<leader>a", vim.lsp.buf.code_action)

  bufmap("gd", vim.lsp.buf.definition)
  bufmap("gD", vim.lsp.buf.declaration)
  bufmap("gI", vim.lsp.buf.implementation)
  bufmap("<leader>D", vim.lsp.buf.type_definition)

  bufmap("gr", require("telescope.builtin").lsp_references)
  bufmap("<leader>s", require("telescope.builtin").lsp_document_symbols)
  bufmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols)

  bufmap("K", vim.lsp.buf.hover)

  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    lsp_formatting(bufnr)
    -- vim.lsp.buf.format({ async = false })
  end, {})

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
        -- vim.lsp.buf.format({ async = false })
      end,
    })
  end
  -- Enable inlay hints if supported
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint(bufnr, true)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- mason
local handlers = {
  function(server_name)
    require("lspconfig")[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,

  ["lua_ls"] = function()
    require("neodev").setup()
    require("lspconfig").lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    })
  end,
}
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "rust_analyzer", "bashls", "clangd", "zls" },
  automatic_installation = true,
  handlers = handlers,
})

-- null_ls
local null_ls = require("null-ls")
null_ls.setup({
  on_attach = on_attach,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.beautysh,
  },
})
