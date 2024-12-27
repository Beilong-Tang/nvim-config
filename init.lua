require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
require "user.cmp"
require "user.telescope"
require "user.gitsigns"
require "user.treesitter"
require "user.autopairs"
require "user.comment"
-- require "user.conform"
require "user.bufferline"
require "user.lualine"
require "user.toggleterm"
require "user.nvim-tree"
require "user.lsp"

-- formatting for python
-- Define a function to run 'black' on the current file
vim.api.nvim_create_user_command('Black', function()
    vim.cmd('silent !black ' .. vim.fn.expand('%'))  -- Run black on the current file
    vim.cmd('checktime')  -- Check if the file was modified and reload it
  end, {})
  
  -- Map <leader>b to the Black command in normal mode
  vim.api.nvim_set_keymap('n', '<leader>b', ':Black<CR>', { noremap = true, silent = true })

vim.o.fileformat = "unix"
  
vim.api.nvim_set_keymap('n', '<leader>b', ':Black<CR>', { noremap = true, silent = true })
vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
      },
      paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
      },
    }
