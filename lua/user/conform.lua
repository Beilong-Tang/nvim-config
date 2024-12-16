require("conform").setup({
  formatters_by_ft = {
    -- Conform will run multiple formatters sequentially
    python = {  "black" },

    cs = {"csharpier"},

    java = {"astyle"},

    c = {"astyle"}
    -- Use a sub-list to run only the first available formatter
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback =false,
  },
})
