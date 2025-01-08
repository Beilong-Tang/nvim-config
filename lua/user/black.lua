-- formatting for python
-- Define a function to run 'black' on the current file
vim.api.nvim_create_user_command('Black', function()
    vim.cmd('silent !black ' .. vim.fn.expand('%'))  -- Run black on the current file
    vim.cmd('checktime')  -- Check if the file was modified and reload it
  end, {})
  
-- Map <leader>b to the Black command in normal mode
vim.api.nvim_set_keymap('n', '<leader>b', ':Black<CR>', { noremap = true, silent = true })
  
vim.api.nvim_set_keymap('n', '<leader>b', ':Black<CR>', { noremap = true, silent = true })