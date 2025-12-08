-- Filetype detection
vim.filetype.add({
  filename = {
    ['config'] = 'toml',
    ['conf'] = 'toml',
  },
})

-- General settings
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.ttyfast = true
vim.opt.compatible = false
vim.opt.list = true
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
vim.opt.wildmode = 'longest,list'
vim.opt.foldmethod = 'marker'
vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:ver25-iCursor,r-cr:hor20-Cursor'
vim.opt.signcolumn = 'yes'

-- Custom highlights for cursor
vim.cmd([[
  highlight Cursor guifg=black guibg=#aaffff
  highlight iCursor guifg=black guibg=#aaffff
  highlight Search guifg=black guibg=#ffb366
]])

-- Enable filetype detection and syntax
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')
