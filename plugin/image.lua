-- Open image files (png, jpg, ...) as images instead of binary garbage.
--
-- * kitty / ghostty / wezterm: snacks.nvim's image module (kitty graphics protocol).
--   It also renders images inline in markdown. Snacks is installed by packer
--   as a dependency of claudecode.nvim.
-- * iTerm2 (also over SSH, where LC_TERMINAL is forwarded): iTerm2 does not
--   speak the kitty protocol, so the image is drawn with iTerm2's own inline
--   image escape (OSC 1337, what `imgcat` uses) on top of an empty buffer.

local formats = { "png", "jpg", "jpeg", "gif", "bmp", "webp" }

local is_iterm = vim.env.TERM_PROGRAM == "iTerm.app" or vim.env.LC_TERMINAL == "iTerm2"

if not is_iterm then
  local ok, snacks = pcall(require, "snacks")
  if ok then
    snacks.setup { image = { enabled = true } }
  end
  return
end

if not vim.api.nvim_ui_send then
  -- nvim < 0.12 has no way to write raw escapes to the terminal
  return
end

local group = vim.api.nvim_create_augroup("user_iterm_image", { clear = true })

local function read_file(path)
  local f = io.open(path, "rb")
  if not f then
    return nil
  end
  local data = f:read "*a"
  f:close()
  return data
end

-- Draw the image of `buf` over `win`, scaled to fit the window
local function draw(win, buf)
  local data = vim.b[buf].iterm_image
  if not data or not vim.api.nvim_win_is_valid(win) then
    return
  end
  local row, col = unpack(vim.api.nvim_win_get_position(win))
  -- Leave the last row free so iTerm2 never scrolls the screen
  local width, height = vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win) - 1
  if width < 1 or height < 1 then
    return
  end
  local seq = ("\27[s\27[%d;%dH\27]1337;File=inline=1;size=%d;width=%d;height=%d;preserveAspectRatio=1:%s\7\27[u"):format(
    row + 1, col + 1, #data, width, height, vim.base64.encode(data))
  if vim.env.TMUX then
    -- Needs `set -g allow-passthrough on` in tmux
    seq = "\27Ptmux;" .. seq:gsub("\27", "\27\27") .. "\27\\"
  end
  vim.api.nvim_ui_send(seq)
end

-- Repaint every visible image. Runs after nvim's own redraw, which would
-- otherwise overwrite the image cells.
local pending = false
local function refresh(clear)
  if pending then
    return
  end
  pending = true
  vim.defer_fn(function()
    pending = false
    if clear then
      vim.cmd "redraw!"
    else
      vim.cmd "redraw"
    end
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      draw(win, vim.api.nvim_win_get_buf(win))
    end
  end, 30)
end

vim.api.nvim_create_autocmd("BufReadCmd", {
  group = group,
  pattern = "*." .. table.concat(formats, ",*."),
  callback = function(ev)
    local buf = ev.buf
    local path = vim.fn.fnamemodify(ev.match, ":p")
    vim.b[buf].iterm_image = read_file(path)
    if not vim.b[buf].iterm_image then
      vim.notify("Cannot read " .. path, vim.log.levels.ERROR)
      return
    end
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "image"
    -- Open in an external viewer (Preview on macOS)
    vim.keymap.set("n", "gx", function()
      vim.ui.open(path)
    end, { buffer = buf, desc = "Open image externally" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "image",
  callback = function()
    -- Keep the window blank so nothing is drawn over the image
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.cursorline = false
    vim.wo.signcolumn = "no"
    vim.wo.list = false
    vim.wo.fillchars = "eob: "
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinResized", "VimResized", "WinClosed", "FocusGained" }, {
  group = group,
  callback = function()
    refresh(false)
  end,
})

-- Wipe leftover image pixels when an image buffer leaves its window
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = group,
  callback = function(ev)
    if vim.b[ev.buf].iterm_image then
      refresh(true)
    end
  end,
})
