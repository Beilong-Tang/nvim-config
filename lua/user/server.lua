-- config nvim on server setting
-- Yank sends text to the local terminal's clipboard via OSC 52.
-- Paste reads Neovim's own registers: many terminals don't answer OSC 52
-- paste requests, which makes `p` hang. Use your terminal's paste
-- (Cmd/Ctrl+Shift+V) for text copied outside Neovim.
local osc52 = require "vim.ui.clipboard.osc52"

local function paste()
  return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = osc52.copy "+",
    ["*"] = osc52.copy "*",
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}
