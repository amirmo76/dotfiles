return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
    view_options = {
      show_hidden = true,
      natural_order = "fast",
      case_insensitive = false,
      sort = {
        { "type", "asc" },
        { "name", "asc" },
      },
      highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
        return nil
      end,
    },
    -- Configuration for the floating window in oil.open_float
    float = {
      padding = 3,
      max_width = 80,
      max_height = 30,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
      get_win_title = nil,
      preview_split = "auto",
      override = function(conf)
        return conf
      end,
    },
  },
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	config = function(_, opts)
		vim.keymap.set("n", "<space>o", require("oil").toggle_float)
		vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>")
		require("oil").setup(opts)
	end,
}
