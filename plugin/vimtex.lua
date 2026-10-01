-- Managed by the built-in plugin manager (vim.pack, nvim 0.12+).
-- Only call vim.pack.add once per plugin; to pin a release instead, use:
--   vim.pack.add { { src = "https://github.com/lervag/vimtex", version = "v2.15" } }
vim.pack.add { "https://github.com/lervag/vimtex" }

-- Skim is the usual macOS viewer with SyncTeX support: brew install --cask skim
vim.g.vimtex_view_method = "skim"

-- latexmk is the default compiler and is already installed, so no setting needed.
-- vim.g.vimtex_compiler_method = "latexmk"

-- Only pop up the quickfix window for errors, not warnings (still listed; open with <localleader>le)
vim.g.vimtex_quickfix_open_on_warning = 0

-- Uncomment to use "," for VimTeX mappings (,ll compile, ,lv view) instead of <Space>
-- vim.g.maplocalleader = ","

-- Fix for `dse` (delete surrounding environment).
-- VimTeX's parser treats a {...} or [...] at the start of the *next* line as an
-- argument of \begin{env}/\end{env}, so `dse` also deleted that text and then
-- failed with "E16: Invalid range". This version only removes \end{env} itself
-- and \begin{env} plus the options/arguments on the same line.
vim.cmd [[
function! UserVimtexEnvDeleteOp(_) abort
  let [l:open, l:close] = vimtex#env#get_surrounding('normal')
  if empty(l:open) | return | endif

  let l:end = l:open.cnum + strlen(l:open.match) - 1
  let l:cmd = get(l:open, 'env_cmd', {})
  for l:part in get(l:cmd, 'args', []) + get(l:cmd, 'opts', [])
    if l:part.close.lnum == l:open.lnum && l:part.close.cnum > l:end
      let l:end = l:part.close.cnum
    endif
  endfor

  let l:pos = getcurpos()
  " Bottom first, so the \begin line number stays valid
  call s:user_env_cut(l:close.lnum, l:close.cnum, l:close.cnum + strlen(l:close.match) - 1)
  if s:user_env_cut(l:open.lnum, l:open.cnum, l:end) && l:pos[1] > l:open.lnum
    let l:pos[1] -= 1
  endif
  let l:pos[1] = min([l:pos[1], line('$')])
  call setpos('.', l:pos)
endfunction

" Remove columns c1..c2 of line lnum; delete the line if left blank.
" Returns 1 if the line was deleted.
function! s:user_env_cut(lnum, c1, c2) abort
  let l:line = getline(a:lnum)
  let l:new = strpart(l:line, 0, a:c1 - 1) . strpart(l:line, a:c2)
  if l:new =~# '^\s*$'
    execute a:lnum . 'delete _'
    return 1
  endif
  call setline(a:lnum, l:new)
  return 0
endfunction
]]

vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventInitPost",
  group = vim.api.nvim_create_augroup("user_vimtex_dse", { clear = true }),
  callback = function(args)
    -- Same shape as VimTeX's own mapping (g@l keeps `.` repeat working)
    vim.keymap.set("n", "<Plug>(vimtex-env-delete)",
      "<Cmd>set operatorfunc=UserVimtexEnvDeleteOp<CR>g@l",
      { buffer = args.buf, silent = true })
  end,
})
