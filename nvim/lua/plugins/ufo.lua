return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = 'BufReadPost',
    init = function()
      -- neovim foldmethod must be manual/expr for ufo to take over
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      local ufo = require 'ufo'

      ufo.setup {
        provider_selector = function(_, filetype, _)
          -- use LSP for known types, fallback to treesitter then indent
          local lsp_types = { 'rust', 'typescript', 'typescriptreact', 'javascript', 'lua', 'go' }
          for _, ft in ipairs(lsp_types) do
            if filetype == ft then
              return { 'lsp', 'treesitter' }
            end
          end
          return { 'treesitter', 'indent' }
        end,

        -- show number of folded lines + preview snippet
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ('  %d lines'):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, 'Comment' })
          return newVirtText
        end,
      }

      -- keymaps
      vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })
      vim.keymap.set('n', 'zr', ufo.openFoldsExceptKinds, { desc = 'Open folds except kinds' })
      vim.keymap.set('n', 'zm', ufo.closeFoldsWith, { desc = 'Close folds with level' })
      vim.keymap.set('n', 'zk', function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = 'Peek fold or hover' })
    end,
  },
}
