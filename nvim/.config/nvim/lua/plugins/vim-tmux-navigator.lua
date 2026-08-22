-- Ctrl+hjkl moves between splits, then out into the surrounding multiplexer.
-- vim-herdr-navigation's editor side owns the mappings (it handles herdr, and
-- falls back to this plugin's TmuxNavigate* commands when $TMUX is set), so
-- vim-tmux-navigator is loaded for its commands only.
return {
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      local nav = vim.fn.glob(
        vim.fn.expand '~/.config/herdr/plugins/github/vim-herdr-navigation-*/editor/nvim.lua'
      )
      -- Only present where the herdr plugin is installed; plain wincmd elsewhere.
      if nav ~= '' then
        dofile(vim.fn.split(nav, '\n')[1])
      end
    end,
  },
}
