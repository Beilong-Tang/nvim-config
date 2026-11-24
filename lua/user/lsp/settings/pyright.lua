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
  -- Point pyright at the active conda/venv python (fallback: bltang_py310),
  -- so imports like torch resolve instead of using base / system python.
  before_init = function(_, config)
    local prefix = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
    if not prefix or prefix == "/opt/anaconda3" then
      prefix = "/opt/anaconda3/envs/bltang_py310"
    end
    -- Copy so per-root changes (exclude list below) don't leak into other clients.
    config.settings = vim.deepcopy(config.settings or {})
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = prefix .. "/bin/python"

    -- Also exclude every directory git ignores (.gitignore, .git/info/exclude,
    -- global excludes). `--directory` collapses fully-ignored dirs to one entry.
    local root = config.root_dir
    if root and vim.fn.executable("git") == 1 then
      local res = vim.system(
        { "git", "ls-files", "--others", "--ignored", "--exclude-standard", "--directory" },
        { cwd = root, text = true }
      ):wait()
      if res.code == 0 and res.stdout then
        local analysis = config.settings.python.analysis or {}
        config.settings.python.analysis = analysis
        analysis.exclude = analysis.exclude or {}
        for line in res.stdout:gmatch("[^\n]+") do
          if line:sub(-1) == "/" then
            table.insert(analysis.exclude, line:sub(1, -2))
          end
        end
      end
    end
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
