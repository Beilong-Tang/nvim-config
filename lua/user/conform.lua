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
