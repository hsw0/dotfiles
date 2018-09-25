
set nocompatible
filetype on "osx bug workaround
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'cscope.vim'

call vundle#end()
filetype plugin indent on

color jellybeans

" ctags
set tags=./tags

" 들여쓰기
set autoindent
set cindent
set smartindent

set ruler

set colorcolumn=80
"set textwidth=79
"set wrap

set fenc=utf8 ff=unix ffs=unix,dos,mac
set fencs=utf8,cp949

" 검색
" set nowrapscan
set incsearch
set hlsearch

set backspace=indent,eol,start


if(has("syntax"))
	syntax on
endif


autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType go compiler go



" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <C-E> :call ToggleVExplorer()<CR>

let g:netrw_browse_split = 4
let g:netrw_altv = 1

let g:pymode_folding = 0



exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
"set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list

if has("gui_running")
	:set guioptions -=m 
	:set guioptions -=T
	:set guifont=Source\ Code\ Pro\ 9
endif


nnoremap <leader>fa :call cscope#findInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>

" s: Find this C symbol
nnoremap  <leader>fs :call cscope#find('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call cscope#find('g', expand('<cword>'))<CR>
