require("conform").setup({
  formatters_by_ft = {
    python = { "isort", "black" }, -- sort imports, then format
    cs = { "csharpier" },
    java = { "astyle" },
    c = { "astyle" },
  },
  format_on_save = function(bufnr)
    -- Skip until the buffer has actually been edited since it was opened.
    -- Once edited, format-on-save stays active for that buffer.
    local b = vim.b[bufnr]
    -- Off by default; buffer setting overrides the global one
    local enabled = b.autoformat
    if enabled == nil then
      enabled = vim.g.autoformat
    end
    if not enabled then
      return
    end
    if not b.format_armed then
      if b.format_initial_tick and b.format_initial_tick == b.changedtick then
        return
      end
      b.format_armed = true
    end
    return { timeout_ms = 2000, lsp_format = "never" } -- 500ms can time out on black's cold start
  end,
})

-- Remember the changedtick once a file has finished loading
-- (scheduled, since filetype/plugin autocmds can bump it after BufReadPost)
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.b[args.buf].format_initial_tick = vim.b[args.buf].changedtick
      end
    end)
  end,
})

-- Format manually (works on a visual selection too)
vim.keymap.set({ "n", "v" }, "<leader>b", function()
  require("conform").format({ async = true, lsp_format = "never" })
end, { desc = "Format buffer" })

-- Toggle format-on-save. :FormatToggle = this buffer, :FormatToggle! = globally
vim.api.nvim_create_user_command("FormatToggle", function(args)
  local scope = args.bang and vim.g or vim.b
  local current = scope.autoformat
  if current == nil then
    current = vim.g.autoformat or false
  end
  scope.autoformat = not current
  vim.notify(
    ("Format on save %s (%s)"):format(
      scope.autoformat and "enabled" or "disabled",
      args.bang and "global" or "buffer"
    )
  )
end, { bang = true, desc = "Toggle format on save" })

vim.keymap.set("n", "<leader>B", "<cmd>FormatToggle<cr>", { desc = "Toggle format on save (buffer)" })
