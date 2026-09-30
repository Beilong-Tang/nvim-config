-- nvim-treesitter `main` branch (required for nvim 0.12+). The old
-- `nvim-treesitter.configs` module no longer exists; highlighting/indent are
-- now enabled per buffer via a FileType autocmd.
local ts_ok, ts = pcall(require, "nvim-treesitter")
if not ts_ok then
  return
end

ts.setup {}
-- Installs asynchronously; no-op for parsers that are already installed.
-- Requires the `tree-sitter` CLI (brew install tree-sitter-cli).
ts.install { "python", "html", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "bash", "json" }

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
  callback = function(args)
    -- Only start when a parser exists for this filetype
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end
    -- Keep regex syntax alongside treesitter (was additional_vim_regex_highlighting = true)
    vim.bo[args.buf].syntax = "on"
    if vim.bo[args.buf].filetype ~= "yaml" then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

vim.cmd([[ autocmd BufRead,BufNewFile *.slurm,*.sbatch setfiletype sh ]])


-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

-- Define custom colors for RainbowDelimiter
local colors = {
  "#D3D3D3", -- soft white
  "#f17e2c",  -- orange
  "#FF87FF",  -- magenta (pink)
  "#FFD700",  -- yellow
  "#87CEEB",  -- sky blue (changed from blue)
  "#eb34c9",  -- purple
  "#87AF87"   -- soft green
}
-- Map colors to RainbowDelimiter groups
local groups = {
  "RainbowDelimiterRed",
  "RainbowDelimiterYellow",
  "RainbowDelimiterBlue",
  "RainbowDelimiterOrange",
  "RainbowDelimiterGreen",
  "RainbowDelimiterViolet",
  "RainbowDelimiterCyan",
}

-- Apply the colors
for i, group in ipairs(groups) do
  vim.api.nvim_set_hl(0, group, { fg = colors[i] })
end

---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    priority = {
        [''] = 110,
        lua = 210,
    },
    highlight = groups,
}


