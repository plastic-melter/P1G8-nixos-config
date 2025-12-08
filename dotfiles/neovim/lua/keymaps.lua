-- Telescope keymaps
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Buffers' })

-- Don't add extra indent with o/O
vim.keymap.set('n', 'o', 'o<Esc>S', { desc = 'Open line without auto-indent' })
vim.keymap.set('n', 'O', 'O<Esc>S', { desc = 'Open line above without auto-indent' })

-- Copy to clipboard with Ctrl-Space
vim.keymap.set('n', '<C-Space>', function()
  vim.fn.system('wl-copy', vim.fn.getreg('"'))
end, { desc = 'Copy to clipboard' })

-- Override mouse scroll to be less sensitive
vim.keymap.set({'n', 'v', 'i'}, '<ScrollWheelUp>', '2<C-y>', { silent = true })
vim.keymap.set({'n', 'v', 'i'}, '<ScrollWheelDown>', '2<C-e>', { silent = true })
