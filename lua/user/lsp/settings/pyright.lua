return {
  autostart = true,
  on_attach = function(client, bufnr)
    print("[LSP] attached to buffer: ", bufnr)
  end,
  root_dir = function(fname)
    local cwd = vim.fn.getcwd()
    print("[Pyright]Resolved root_dir: ", cwd)
    return cwd
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
}