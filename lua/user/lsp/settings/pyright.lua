return {
  autostart = true,
  -- vim.lsp.config signature: root_dir(bufnr, on_dir)
  -- Prefer a real project root (git / python project files); fall back to cwd.
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      "pyrightconfig.json",
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      ".git",
    }) or vim.fn.getcwd()
    on_dir(root)
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        -- Only analyze files that are open instead of the whole workspace;
        -- workspaces with huge data/sample/checkpoint dirs otherwise stall indexing.
        diagnosticMode = "openFilesOnly",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        -- Overrides pyright's default excludes, so keep those too.
        -- Ignored if the project has its own pyrightconfig.json / [tool.pyright].
        exclude = {
          "**/node_modules",
          "**/__pycache__",
          "**/.*",
          "**/samples",
          "**/cache",
          "**/ckpts*",
          "**/checkpoints",
          "**/logs",
          "**/data",
          "**/datasets",
          "**/outputs",
          "**/wandb",
          "**/gpu_usage",
        },
      },
    },
  },
}
