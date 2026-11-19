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
  -- Point pyright at the active conda/venv python (fallback: bltang_py310),
  -- so imports like torch resolve instead of using base / system python.
  before_init = function(_, config)
    local prefix = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
    if not prefix or prefix == "/opt/anaconda3" then
      prefix = "/opt/anaconda3/envs/bltang_py310"
    end
    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = prefix .. "/bin/python"
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
}