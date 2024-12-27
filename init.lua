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


-- check if to use ssh
local config_module = require("utils.read_config")
-- Use the 'read_config' function from the imported module
local config = config_module.read_config("config.conf")

if config['env'] == 'ssh' then
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
end

-- Function to surround the comment with hashes and replace any existing borders
vim.api.nvim_set_keymap('n', '<F3>', ':lua SurroundCommentWithHashes()<CR>', { noremap = true, silent = true })

function SurroundCommentWithHashes()
    -- Get the current line content
    local line = vim.api.nvim_get_current_line()
    
    -- Check if the line is a comment starting with #
    if string.match(line, "^#") then
        -- Calculate the length of the entire comment line, including the # symbols
        local length = #line
        
        -- Create the border using the exact length
        local border = string.rep('#', length)

        -- Get the current line number (1-based)
        local current_line = vim.fn.line('.')
        
        -- Get the content of the line above
        local above_line_content = vim.api.nvim_buf_get_lines(0, current_line - 2, current_line - 1, false)[1]
        
        -- Check if the line above is also a border (starts with #)
        if above_line_content and string.match(above_line_content, "^#") then
            vim.api.nvim_buf_set_lines(0, current_line - 2, current_line - 1, false, { border })  -- Replace the top border
        else
            vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, { border })  -- Add the top border
            current_line = current_line + 1
        end
        -- Get the content of the line below
        local below_line_content = vim.api.nvim_buf_get_lines(0, current_line, current_line + 1, false)[1]

        -- Check if the line below is also a border (starts with #)
        if below_line_content and string.match(below_line_content, "^#") then
            vim.api.nvim_buf_set_lines(0, current_line, current_line + 1, false, { border })  -- Replace the bottom border
        else
            vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { border })  -- Add the bottom border
        end
    else
        
        print("Not a comment line.")  -- Debugging output
    end
end
