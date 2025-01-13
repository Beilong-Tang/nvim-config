require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
require "user.cmp"
require "user.telescope"
require "user.treesitter"
require "user.autopairs"
require "user.comment"
-- require "user.conform"
require "user.bufferline"
require "user.lualine"
require "user.toggleterm"
require "user.nvim-tree"
require "user.lsp"
require "user.black"

-- If on a server, can enable this 
-- require "user.gitsigns" -- # This is disabled due to performance issues on local machine. It should be fine on server.
-- require "user.server" -- # Enable copy on a server


-- require("catppuccin").setup({
--     no_italic = true, -- Force no italic
-- })

-- -- setup must be called before loading
-- vim.cmd.colorscheme "catppuccin-latte"

-- This is used after LspRestart is finished 
vim.api.nvim_create_user_command('EditAllBuffers', function()
    -- Get all listed buffers
    local buffers = vim.api.nvim_list_bufs()
    
    -- Loop through each buffer and call :edit
    for _, buf in ipairs(buffers) do
      -- Skip `nvim-tree` buffer or any other specific buffer types
      local bufname = vim.api.nvim_buf_get_name(buf)
      if vim.api.nvim_buf_is_loaded(buf) and not bufname:match("NvimTree") then
        vim.api.nvim_command("buffer " .. buf)  -- Switch to the buffer
        vim.cmd("edit")  -- Reload the buffer
      end
    end
  end, {desc = "Edit all buffers except nvim-tree"})