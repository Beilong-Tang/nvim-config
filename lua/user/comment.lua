local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end

comment.setup {
  pre_hook = function(ctx)
    local U = require "Comment.utils"

    -- Override commentstring for Python
    if vim.bo.filetype == "python" then
      return "# %s"
    end

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring {
      key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
      location = location,
    }
  end,
}

require('ts_context_commentstring').setup {}

vim.g.skip_ts_context_commentstring_module = true



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