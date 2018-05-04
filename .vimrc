if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

" Toggle line numbers
nmap <C-N><C-N> :set invnumber<CR>

let mapleader = "\<Space>"
:nmap <leader>w  :w<CR>
:nmap <leader>fs :w<CR>
:nmap <leader>q  :q<CR>
:nmap <leader>wq :wq<CR>

" Toggle search-highlight
:nmap <leader><space> :set hlsearch!<CR>

" Jump between bracket pairs with <TAB> in I & V
" Note: With this enabled, the ctrl-i will not navigate you back in the jumps
"nnoremap <tab> %
"vnoremap <tab> %


" Pathogen
"filetype off " Pathogen needs to run before plugin indent on
"call pathogen#runtime_append_all_bundles()
"call pathogen#helptags() " generate helptags for everything in 'runtimepath'
"filetype plugin indent on

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
set ai			    " always set autoindenting on
"set backup		    " keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " In text files, always limit the width of text to 78 characters
  "autocmd BufRead *.txt set tw=78 " Noo, this is silly, why would I need this?
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " When editing python files, enable folding
  autocmd FileType python setlocal foldenable foldmethod=indent

  " Syntax on for ttcn
  autocmd BufRead,BufNewFile *.ttcn setfiletype ttcn

  " Save and restore folds
  autocmd BufWinLeave ?* mkview
  autocmd BufWinEnter ?* silent loadview

  " Set the cursor to first line for git commit messages
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
endif

" Default fold level = Show eveything (more than 200 levels are ridiculous)
set foldlevel=200

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1

set title
set titleold= " Don't set the title to 'Thanks for flying Vim' when exiting

set background=dark
set tabstop=4
set shiftround " when at 3 spaces, and I hit > ... go to 4, not 5
set shiftwidth=4
set expandtab
set number
syntax on
set incsearch
set hlsearch

set wildmenu
set wildmode=longest:full,full

set splitbelow " When splitting horizontally place new window below
set splitright " when splitting vertically place new window to the right

set laststatus=2
set statusline=%<[%02n]\ %F%(\ %m%h%w%y%r%)\ %a%=\ %8l,%c%V/%L\ (%P)\ [%08O:%02B]


" Settings for file explorer :Exporer
" t - open in new tab
" <cr> - open in preview window
" 
let g:netrw_liststyle=3 " Tree view
let g:netrw_preview=1 " Preview window shown in a vertically split
let g:netrw_browse_split=4 " Open file in previous buffer
let g:netrw_winsize = -28 " Shrink the width a little
let g:netrw_banner = 0 " No need for the help at the top

" Change directory to the current buffer when opening files.
"set autochdir

" Toggle Vexplore
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
nnoremap <leader><tab> :call ToggleVExplorer()<cr>



" Tab navigation
" gt and gT for neighbours
let g:lasttab = 1
nnoremap <Leader>t :exe "tabn ".g:lasttab<cr>
au TabLeave * let g:lasttab = tabpagenr()

noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

