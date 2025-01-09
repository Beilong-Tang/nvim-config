return {
  root_dir = function(fname)
    return vim.loop.cwd() -- Keeps the root directory fixed to the current working directory
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
}