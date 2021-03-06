
augroup misc_group
    autocmd!
    autocmd CmdwinEnter * noremap <buffer> q :q<cr> | nunmap <buffer> <cr>
    au BufRead * if &ff=="dos" | setlocal ffs=dos,unix,mac | endif  
    au VimResized * wincmd = 
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
                \ exe "normal! g'\"" |
                \ endif "jump to last position last open in vim
    autocmd VimEnter * call te#feat#run_vim_enter_setting()
augroup END

augroup filetype_group
    autocmd!
    au BufRead,BufNewFile *.vt setlocal filetype=verilog
    "automatic recognition bld file as javascript 
    au BufRead,BufNewFile *.bld setlocal filetype=javascript
    "automatic recognition xdc file as javascript
    au BufRead,BufNewFile *.xdc setlocal filetype=javascript
    au BufRead,BufNewFile *.mk setlocal filetype=make
    au BufRead,BufNewFile *.make setlocal filetype=make
    au BufRead,BufNewFile *.veo setlocal filetype=verilog
    au BufRead,BufNewFile *.h setlocal filetype=c
    au BufRead,BufNewFile * let $CurBufferDir=expand('%:p:h')
    au BufRead,BufNewFile *.hex,*.out,*.o,*.a Vinarise
    au BufRead,BufNewFile *.fex setlocal filetype=dosini

    if get(g:,'feat_enable_airline') != 1
        au BufEnter * 
                    \ if &diff |
                    \ set statusline=%!MyStatusLine(2) |
                    \ endif
    endif
    autocmd FileType qf noremap <buffer> r :<C-u>:q<cr>:silent! Qfreplace<CR>
    " quickfix window  s/v to open in split window,  ,gd/,jd => quickfix window => open it
    autocmd FileType qf noremap <buffer> s <C-w><Enter><C-w>K
    autocmd FileType qf nnoremap <buffer> q :ccl<cr>
    autocmd FileType sh setlocal foldmethod=indent
    autocmd FileType qfreplace setlocal nofoldenable | nmap <buffer> q :bdelete<cr>
    autocmd FileType gitcommit setlocal nofoldenable cursorline
augroup END
if te#env#IsNvim()
    au misc_group TermOpen * setlocal nonu signcolumn=no
endif


