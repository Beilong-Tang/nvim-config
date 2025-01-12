local configs = require("nvim-treesitter.configs")
configs.setup {
  ensure_installed = {"python"},
  sync_install = false, 
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopairs = {
		enable = true,
	},
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,

  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  -- rainbow = {
  --   enable = true,
  --   -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
  --   extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
  --   max_file_lines = nil, -- Do not enable for files with more than n lines, int
  --   colors = {
  --     "#D3D3D3",  -- soft white
  --     "#FF6A00",  -- orange
  --     "#FF87FF",  -- magenta
  --     "#D7AFFF",  -- light purple
  --     "#AFD7FF",  -- light blue
  --     "#FFD700",  -- yellow
  --     "#87AF87",  -- soft green
  --   }
  --   -- termcolors = {} -- table of colour name strings
  -- }
}
vim.cmd([[ autocmd BufRead,BufNewFile *.slurm,*.sbatch setfiletype sh ]])


-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

-- Define custom colors for RainbowDelimiter
local colors = {
  "#D3D3D3", -- soft white
  "#FF6A00",  -- orange
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