local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require "user.lsp.mason"
require("user.lsp.handlers").setup()


-- This is used after LspRestart is finished
-- Make sure to save all the buffers before using it
vim.api.nvim_create_user_command('EditAllBuffers', function()
  -- Get all listed buffers
  local buffers = vim.api.nvim_list_bufs()
  
  -- Loop through each buffer and call :edit
  for _, buf in ipairs(buffers) do
    -- Get the buffer name
    local bufname = vim.api.nvim_buf_get_name(buf)

    -- Skip nvim-tree buffers, unnamed buffers, or unloaded buffers
    if vim.api.nvim_buf_is_loaded(buf) and bufname ~= "" and not bufname:match("NvimTree") then
      vim.api.nvim_command("buffer " .. buf)  -- Switch to the buffer
      vim.cmd("edit")  -- Reload the buffer
    end
  end
end, {desc = "Edit all buffers except nvim-tree and unnamed buffers"})



vim.api.nvim_create_user_command('LspRestartAndEditAllBuffers', function()
  -- First, restart LSP
  vim.cmd("LspRestart")

  -- Create an autocommand to call EditAllBuffers after LSP has attached
  vim.api.nvim_create_autocmd('LspAttach', {
      callback = function()
          -- Run EditAllBuffers once LSP has attached
          vim.cmd("EditAllBuffers")

          -- Optionally, remove the autocommand after it has run to avoid it firing again
          vim.api.nvim_del_autocmd({group = "LspRestartGroup", id = vim.fn.expand("<amatch>")})
      end,
      group = "LspRestartGroup",  -- Group to manage this autocmd easily
      once = true  -- Automatically remove the autocmd after it runs once
  })
end, { desc = "Restart LSP and edit all buffers after LSP attaches" })