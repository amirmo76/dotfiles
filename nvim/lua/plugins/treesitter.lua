return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("nvim-treesitter").setup()

      local ensure_installed = {
        "go",
        "lua",
        "rust",
        "typescript",
        "javascript",
        "tsx",
        "toml",
      }

      -- auto-install missing parsers
      local installed = require("nvim-treesitter.config").get_installed("parsers")
      local to_install = vim.tbl_filter(function(lang)
        return not vim.list_contains(installed, lang)
      end, ensure_installed)

      if #to_install > 0 then
        vim.cmd("TSInstall " .. table.concat(to_install, " "))
      end

      -- auto-install parser for new filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
          if lang then
            pcall(vim.treesitter.start, ev.buf, lang)
          end
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        aliases = {
          ["template"] = "html",
        },
      })
    end,
  },
}
