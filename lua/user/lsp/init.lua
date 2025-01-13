local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require "user.lsp.mason"
require("user.lsp.handlers").setup()



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
