-- following options are the default

-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', '<C-x>',   api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-z>',   api.node.open.horizontal,            opts('Open: Horizontal Split'))
end

-- current tree width; updated on resize so toggling keeps it (see bottom of file)
local tree_width = 30

nvim_tree.setup({
    -- wrap = false,
    -- disable_netrw = true,
    -- hijack_netrw = true,
    -- respect_buf_cwd = true,
    -- sync_root_with_cwd = false,
    -- --[[ open_on_setup = false, ]]
    -- --[[ ignore_ft_on_setup = { ]]
    -- --[[     "startify", ]]
    -- --[[     "dashboard", ]]
    -- --[[     "alpha", ]]
    -- --[[ }, ]]
    -- on_attach = my_on_attach,
    -- open_on_tab = false,
    -- hijack_cursor = false,
    -- update_cwd = false,
    -- hijack_directories = {
    --     enable = false,
    --     auto_open = true,
    -- },
    update_focused_file = {
      enable = true,
      update_cwd = false,
      ignore_list = {},
  },

  filesystem_watchers = {
      enable = true,
  },
    filters = {
        dotfiles = false,
    },
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = false,
        ignore_list = {},
    },
    git = {
        enable = true,
        ignore = false,
        timeout = 400,
    },
    view = {
        width = function() return tree_width end,
        --[[ height = 30, ]]
        --[[ hide_root_folder = false, ]]
        side = "left",
        -- [[ auto_resize = true, ]]
        --[[ mappings = { ]]
        --[[     custom_only = false, ]]
        --[[     }, ]]
        number = false,
        relativenumber = false,
        preserve_window_proportions = false,
    },
    actions = {
        change_dir={
        enable = true,
    },
    open_file = {
        resize_window = false,  -- Prevents resizing the tree window when opening a file
      },
        --[[ quit_on_open = true, ]]
        --[[ window_picker = { enable = true }, ]]
    },
    renderer = {
        highlight_git = true,
        root_folder_modifier = ":t",
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "",
                    staged = "S",
                    unmerged = "",
                    renamed = "➜",
                    deleted = "",
                    untracked = "U",
                    ignored = "◌",
                },
                folder = {
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                },
            }
        }
    }
})

-- ---------------------------------------------------------------------------
-- Keep tree width across toggles + shortcuts to resize it
-- ---------------------------------------------------------------------------
local function tree_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "NvimTree" then
            return win
        end
    end
end

-- remember width whenever the tree window is resized (mouse drag, <C-w>< / <C-w>>, ...)
vim.api.nvim_create_autocmd("WinResized", {
    callback = function()
        local win = tree_win()
        if win then tree_width = vim.api.nvim_win_get_width(win) end
    end,
})

local function resize_tree(delta)
    tree_width = math.max(10, tree_width + delta)
    local win = tree_win()
    if win then vim.api.nvim_win_set_width(win, tree_width) end
end

vim.keymap.set("n", "<leader>>", function() resize_tree(5) end,  { desc = "NvimTree wider" })
vim.keymap.set("n", "<leader><", function() resize_tree(-5) end, { desc = "NvimTree narrower" })
