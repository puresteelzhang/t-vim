"File       vimrc 
"Brief      config file for neovim,vim,gvim in linux,gvim in win32,macvim
"Date       2015-11-28/22:56:20
"Author     tracyone,tracyone@live.cn,
"Github     https://github.com/tracyone/t-vim
"Website    http://onetracy.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &compatible
  set nocompatible
endif

if te#env#IsWindows()
    let $HOME=$VIM
    let $VIMFILES = $VIM.'/vimfiles'
else
    let $VIMFILES = $HOME.'/.vim'
endif

let g:feature_dict={}

function! s:source_rc(path, ...) abort "{{{
  let use_global = get(a:000, 0, !has('vim_starting'))
  let abspath = resolve(expand($VIMFILES.'/rc/' . a:path))
  if !use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
  let content = map(readfile(abspath),
        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
  " create tempfile and source the tempfile
  let tempfile = tempname()
  try
    call writefile(content, tempfile)
    execute 'source' fnameescape(tempfile)
  finally
    if filereadable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction

function! s:set(var, default) abort
  if !exists(a:var)
    if type(a:default)
      execute 'let' a:var '=' string(a:default)
    else
      execute 'let' a:var '=' a:default
      let g:feature_dict[a:var]=a:default
    endif
  endif
  if eval(a:var) == 1
      call s:source_rc(matchstr(a:var,'_\zs[^_]*\ze$').'.vim')
  endif
endfunction

function! s:GenFeatureVim()
	for key in keys(g:feature_dict)
	   call writefile(['let '.key.'='.g:feature_dict[key]], $VIMFILES.'/feature.vim', 'a')
	endfor
endfunction
"}}}

call s:source_rc('autocmd.vim')
call s:source_rc('options.vim')
call s:source_rc('mappings.vim')

if filereadable($VIMFILES.'/feature.vim')
    execute ':source '.$VIMFILES.'/feature.vim'
endif

let &rtp=&rtp.','.$VIMFILES
if empty(glob($VIMFILES.'/autoload/plug.vim'))
    if te#env#IsWindows()
        silent! exec ':!mkdir -p '.$VIMFILES.'\\autoload'
        silent! exec ':!curl -fLo ' . $VIMFILES.'\\autoload'.'\\plug.vim ' .
                    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    else
        silent! exec ':!mkdir -p '.$VIMFILES.'/autoload'
        silent! exec ':!curl -fLo ' . $VIMFILES.'/autoload'.'/plug.vim ' .
                    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
endif
call plug#begin($VIMFILES.'/bundle')

call s:set('g:complete_plugin_type','ycm')
call s:set('g:feat_enable_complete', 0)
call s:set('g:feat_enable_jump', 1)
call s:set('g:feat_enable_tmux', 0)
call s:set('g:feat_enable_git', 0)
call s:set('g:feat_enable_c', 0)
call s:set('g:feat_enable_markdown', 0)
call s:set('g:feat_enable_vim', 0)
call s:set('g:feat_enable_gui', 0)
call s:set('g:feat_enable_tools', 0)
call s:set('g:feat_enable_edit', 0)
call s:set('g:feat_enable_frontend', 0)
call s:set('g:feat_enable_basic', 1)
call s:set('g:feat_enable_help', 0)

if !filereadable($VIMFILES.'/feature.vim')
    call s:GenFeatureVim()
endif

" Open plug status windows
nnoremap <Leader>ap :PlugStatus<cr>:only<cr>
call plug#end()

filetype plugin indent on
syntax on
set modeline
