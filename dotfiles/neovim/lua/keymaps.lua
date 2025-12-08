-- Telescope keymaps
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Buffers' })

-- Copy to clipboard with Ctrl-Space
vim.keymap.set('n', '<C-Space>', function()
  vim.fn.system('wl-copy', vim.fn.getreg('"'))
end, { desc = 'Copy to clipboard' })
