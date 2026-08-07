return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  keys = {
    {
      "<leader>gd",
      function()
        if next(require("diffview.lib").views) ~= nil then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "Diffview: Toggle",
    },
    { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "Git: File history (repo)" },
    { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "Git: File history (file)" },
    { "<leader>gf", ":'<,'>DiffviewFileHistory<CR>", mode = "v", desc = "Git: File history (file)" },
  },
  opts = {},
}
