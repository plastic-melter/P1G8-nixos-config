-- Telescope keymaps
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Buffers' })

-- Backspace deletes 2 spaces in insert mode
vim.keymap.set('i', '<BS>', function()
  local col = vim.fn.col('.')
  local line = vim.fn.getline('.')
  -- Check if we're in leading whitespace with 2+ spaces before cursor
  local before = line:sub(1, col-1)
  if before:match('^%s+$') and #before >= 2 then
    -- Delete 2 spaces at a time
    return '<BS><BS>'
  elseif col > 2 and line:sub(col-2, col-1) == '  ' then
    -- Also catch 2 spaces anywhere
    return '<BS><BS>'
  end
  return '<BS>'
end, { expr = true, desc = 'Smart backspace' })

-- Keep indent level when opening new line
vim.keymap.set('n', 'o', function()
  local indent = vim.fn.indent('.')
  return 'o' .. string.rep(' ', indent)
end, { expr = true, desc = 'Open line with current indent' })

vim.keymap.set('n', 'O', function()
  local indent = vim.fn.indent('.')
  return 'O' .. string.rep(' ', indent)
end, { expr = true, desc = 'Open line above with current indent' })

-- Copy to clipboard with Ctrl-Space
vim.keymap.set('n', '<C-Space>', function()
  vim.fn.system('wl-copy', vim.fn.getreg('"'))
end, { desc = 'Copy to clipboard' })
