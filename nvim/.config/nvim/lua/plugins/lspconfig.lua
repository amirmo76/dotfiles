return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities =
        vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        pattern = { '*.rs' },
        callback = function()
          vim.lsp.buf.format()
        end,
      })

      ---@diagnostic disable-next-line: unused-local
      local on_attach = function(_client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
      end

      vim.lsp.config('lua_ls', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            format = {
              enable = false,
            },
            diagnostics = {
              globals = { 'vim' },
              disable = { 'different-requires' },
            },
          },
        },
      })
      vim.lsp.enable 'lua_ls'

      vim.lsp.config('rust_analyzer', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            cargo = {
              features = 'all',
            },
            procMacro = {
              ignored = {
                leptos_macro = {
                  'component',
                  'server',
                },
              },
            },
            check = {
              command = 'clippy',
            },
            inlayHints = {
              enable = true,
            },
            assist = {
              importGranularity = 'module',
            },
          },
        },
      })
      vim.lsp.enable 'rust_analyzer'

      vim.lsp.config('ts_ls', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable 'ts_ls'

      vim.lsp.config('html', {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { 'html' },
      })
      vim.lsp.enable 'html'

      vim.lsp.config('htmx', {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { 'html' },
      })
      vim.lsp.enable 'htmx'

      vim.filetype.add {
        extension = { wgsl = 'wgsl' },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        pattern = { '*.wgsl' },
        callback = function()
          vim.lsp.buf.format()
        end,
      })
      vim.lsp.config('wgsl_analyzer', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable 'wgsl_analyzer'
    end,
  },
}
