-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.scrolloff = 1
vim.opt.listchars = {
  tab = '> ',
  trail = '.',
  space = '.',
}

-- Start lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

-- Snippets
vim.g.lua_snippet_path = vim.fn.stdpath 'config' .. '/lua/snippets/'

-- Tabs
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

-- Clipboard
vim.o.clipboard = 'unnamedplus'

-- Line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Mouse
vim.o.mouse = 'a'

-- Wrapped line indents to match
vim.o.breakindent = true

-- Seach
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn
vim.wo.signcolumn = 'yes'

-- Timings (crisp & snappy!)
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Completion UX
vim.o.completeopt = 'menuone,noselect'

-- Colors
vim.o.termguicolors = true

-- Mason
local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
vim.env.PATH = vim.fn.stdpath 'data'
  .. '/mason/bin'
  .. (is_windows and ';' or ':')
  .. vim.env.PATH

require('lazy').setup 'plugins'
