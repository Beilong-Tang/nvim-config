
local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	--[[ shell = "zsh", ]]
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

-- True if the terminal's foreground program is a vim-like TUI that needs <esc> itself
local passthrough_progs = { nvim = true, vim = true, vi = true, lazygit = true, htop = true }
local function fg_wants_esc()
  local pid = vim.b.terminal_job_pid
  if not pid then return false end
  -- the job itself (e.g. lazygit terminal) plus its direct children (`nvim file` from the shell, `git commit` -> vim)
  local out = vim.fn.system({ "ps", "-o", "comm=", "-p", tostring(pid), "--ppid", tostring(pid) })
  for name in out:gmatch("[^\n]+") do
    if passthrough_progs[vim.trim(name)] then return true end
  end
  return false
end

local function smart_exit(key)
  return function()
    if fg_wants_esc() then
      return key -- send the key through to the inner program
    end
    return [[<C-\><C-n>]]
  end
end

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.keymap.set('t', '<esc>', smart_exit('<esc>'), { buffer = 0, expr = true })
  vim.keymap.set('t', 'jk', smart_exit('jk'), { buffer = 0, expr = true })
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

-- Only toggleterm terminals; leave other terminals (e.g. claudecode.nvim) alone so <esc> reaches the program
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end

local node = Terminal:new({ cmd = "node", hidden = true })

function _NODE_TOGGLE()
	node:toggle()
end

local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })

function _NCDU_TOGGLE()
	ncdu:toggle()
end

local htop = Terminal:new({ cmd = "htop", hidden = true })

function _HTOP_TOGGLE()
	htop:toggle()
end

local python = Terminal:new({ cmd = "python", hidden = true })

function _PYTHON_TOGGLE()
	python:toggle()
end


-- " set
-- autocmd TermEnter term:*toggleterm#*
--       \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>

-- " By applying the mappings this way you can pass a count to your
-- " mapping to open a specific window.
-- " For example: 2<C-t> will open terminal 2

-- nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
-- inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
