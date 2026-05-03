return {
  'kylechui/nvim-surround',
  version = '*', -- use latest stable
  event = 'VeryLazy',
  config = function()
    require('nvim-surround').setup {}
  end,
}

-- =============================================================================
-- CHEAT SHEET
-- =============================================================================
-- // TEXT OBJECTS (use with ys/ds/cs):
-- iw  = inner word
-- aw  = a word (includes space)
-- is  = inner sentence
-- ip  = inner paragraph
-- i"  = inner quotes
-- a"  = around quotes (includes quotes)
-- i)  = inner parens
-- a)  = around parens (includes parens)
-- it  = inner tag (content only)
-- at  = around tag (includes tag itself)
-- =============================================================================
-- COMMON PATTERNS:
-- ysiw"        wrap word in quotes
-- ysiw)        wrap word in ()
-- ysiw t       wrap word in JSX tag
-- ysat t       wrap entire tag+children in new tag
-- dst          delete surrounding tag
-- cst          change tag to different tag
-- cs"'         swap quote style
-- yss)         wrap entire line in ()
-- =============================================================================
