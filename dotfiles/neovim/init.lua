-- Catppuccin theme setup
require('catppuccin').setup({
  flavour = 'mocha',
  transparent_background = true,
  integrations = {
    treesitter = true,
    telescope = { enabled = true },
    gitsigns = true,
    indent_blankline = { enabled = true },
  },
})
vim.cmd.colorscheme('catppuccin')

-- Load modular configs
require('settings')
require('keymaps')
require('plugins')
