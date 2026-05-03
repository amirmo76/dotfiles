local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local null_ls = require 'null-ls'

return {
  sources = {
    null_ls.builtins.formatting.alejandra,
    null_ls.builtins.formatting.goimports_reviser,
    null_ls.builtins.formatting.golines,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd,
  },
  on_attach = function(client, bufnr)
    if vim.lsp.client.supports_method(client, 'textDocument/formatting') then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format {
            bufnr = bufnr,
            filter = function(c)
              return c.name == 'null-ls'
            end,
          }
        end,
      })
    end
  end,
}
