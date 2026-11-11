-- Reload buffers when files change on disk (e.g. edited by Claude Code or another process).
-- 'autoread' is on by default, but nvim only checks the disk on a few events; poll as well.
vim.o.autoread = true

local function check()
  -- checktime is not allowed in cmdline mode or the cmdline window
  if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
    vim.cmd("silent! checktime")
  end
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("user_autoreload", { clear = true }),
  callback = check,
})

-- poll every second so the buffer updates even when nvim is idle and has no focus events
local timer = vim.uv.new_timer()
timer:start(1000, 1000, vim.schedule_wrap(check))

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = "user_autoreload",
  callback = function()
    vim.notify("File changed on disk, buffer reloaded", vim.log.levels.INFO)
  end,
})
