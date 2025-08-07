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
print("lsp setting completed")
require "user.black"


-- Disable italics for specific highlight groups

-- If on a server, can enable this 
require "user.gitsigns" -- # This is disabled due to performance issues on local machine. It should be fine on server.
-- require "user.server" -- # Enable copy on a server


-- require("catppuccin").setup({
--     no_italic = true, -- Force no italic
-- })

-- -- setup must be called before loading
vim.cmd.colorscheme "catppuccin-latte"

-- function g:open_browser(url) abort
--     " open url here
--   endfunction
  
--   let g:mkdp_browserfunc = 'g:open_browser'


-- Disable italic for HTML attribute highlights
vim.api.nvim_set_hl(0, '@tag.attribute', { italic = false }) -- TreeSitter group
vim.api.nvim_set_hl(0, 'htmlArg', { italic = false })        -- Built-in HTML syntax group

-- For markdown preview, do not close the window after changing buffer.
vim.g.mkdp_auto_close = 0