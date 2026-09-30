return {
  autostart = true,
  on_attach = function(client, bufnr)
    print("[LSP] attached to buffer: ", bufnr)
  end,
  -- vim.lsp.config signature: root_dir(bufnr, on_dir)
  root_dir = function(_, on_dir)
    local cwd = vim.fn.getcwd()
    print("[Pyright]Resolved root_dir: ", cwd)
    on_dir(cwd)
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
}