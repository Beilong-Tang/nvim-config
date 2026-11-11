-- In-buffer markdown rendering (headings, code blocks, tables, checkboxes, ...).
-- Uses the markdown / markdown_inline treesitter parsers from lua/user/treesitter.lua.
-- On nvim < 0.12 (no vim.pack) it is installed by packer instead (see lua/user/plugins.lua).
-- For a browser preview, markdown-preview.nvim is still available (:MarkdownPreview).
if vim.pack then
  vim.pack.add { "https://github.com/MeanderingProgrammer/render-markdown.nvim" }
end

local ok, render_markdown = pcall(require, "render-markdown")
if not ok then
  return
end

render_markdown.setup {
  -- Show raw markdown on the cursor line, rendered everywhere else
  anti_conceal = { enabled = true },
}

vim.keymap.set("n", "<leader>m", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle markdown rendering" })
