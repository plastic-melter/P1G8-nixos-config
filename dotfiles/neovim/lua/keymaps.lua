-- Telescope keymaps
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Buffers' })
-- Backspace deletes 2 spaces in insert mode
vim.keymap.set('i', '<BS>', function()
  local col = vim.fn.col('.')
  local line = vim.fn.getline('.')
  -- Check if we're after spaces
  if col > 2 and line:sub(col-2, col-1) == '  ' then
    return '<BS><BS>'
  end
  return '<BS>'
end, { expr = true, desc = 'Smart backspace' })

-- Copy to clipboard with Ctrl-Space
vim.keymap.set('n', '<C-Space>', function()
  vim.fn.system('wl-copy', vim.fn.getreg('"'))
end, { desc = 'Copy to clipboard' })
