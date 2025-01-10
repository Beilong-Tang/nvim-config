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
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    colors = {
      "#D3D3D3",  -- soft white
      "#FF6A00",  -- orange
      "#FF87FF",  -- magenta
      "#D7AFFF",  -- light purple
      "#AFD7FF",  -- light blue
      "#FFD700",  -- yellow
      "#87AF87",  -- soft green
    }
    -- termcolors = {} -- table of colour name strings
  }
}
vim.cmd([[ autocmd BufRead,BufNewFile *.slurm,*.sbatch setfiletype sh ]])