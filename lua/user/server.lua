-- config nvim on server setting
-- Yank sends text to the local terminal's clipboard via OSC 52.
-- Paste returns whatever was last copied inside Neovim (cached here):
-- many terminals don't answer OSC 52 paste requests, which makes `p` hang.
-- Use your terminal's paste (Cmd/Ctrl+Shift+V) for text copied outside Neovim.
local osc52 = require "vim.ui.clipboard.osc52"

local cache = { ["+"] = { {}, "v" }, ["*"] = { {}, "v" } }

local function copy(reg)
  local send = osc52.copy(reg)
  return function(lines, regtype)
    cache[reg] = { lines, regtype }
    send(lines, regtype)
  end
end

local function paste(reg)
  return function()
    return cache[reg]
  end
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = copy "+",
    ["*"] = copy "*",
  },
  paste = {
    ["+"] = paste "+",
    ["*"] = paste "*",
  },
}
