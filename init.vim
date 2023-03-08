if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

set rtp+=~/.fzf
set rtp+=~/proj/neovim/build/runtime " Since I use neovim from build directly, gain (all) syntax for vim for example

set list listchars=tab:>\ ,trail:-,eol:$
set nolist

" Toggle signcolumn
function! ToggleSignColumn()
    if !exists("b:signcolumn_on") || b:signcolumn_on
        set signcolumn=no
        let b:signcolumn_on=0
    else
        set signcolumn=yes
        let b:signcolumn_on=1
    endif
endfunction

" Toggle colorcolumn, so that we can copy block without trailing white-spaces
function! ToggleCC()
  let &cc = &cc == 0 ? 121 : 0
endfunction

" Toggle line numbers
nmap <C-N><C-N> :set invnumber<CR>:set relativenumber!<CR>:call ToggleSignColumn()<CR>:call ToggleCC()<CR>
let b:signcolumn_on=1
set signcolumn=yes

let mapleader = "\<Space>"
:nmap <leader>qq :q<CR>
:nmap <leader>fs :w<CR>
:nmap <leader>fr :Files<Space>
:nmap <leader>fF :Files <c-r>=expand("%:p:h")<CR>
:nmap <leader>ff :Files %:p:h<CR>
:nmap <leader>fg :GFiles <c-r>=expand("%:p:h")<CR><CR>
:nmap <leader>fG :GFiles <c-r>=expand("%:p:h")<CR>
:nmap <leader>fb :Vexplore<CR>
:nmap <leader>fa :call CurtineIncSw()<CR>
:nmap <leader>gs :Git<CR>
:nmap <leader>bb :Buffers<CR>
:nmap <leader>bd :Bdelete<CR>
:nmap <leader>bD :Bwipeout<CR>
:nmap <leader>qa :qa<CR>
:nmap <leader>qa! :qa!<CR>
:nmap <leader>q! :q!<CR>
:nmap <leader>w! :w!<CR>
" Search for current word, but leave it at ex so that we can modify it if needed
" Note: Trailing by intention
:nmap <leader>/ :RG <c-r>=expand("<cword>")<CR><Space>
:nmap <leader>? :RG <c-r>=expand("<cword>")<CR> <c-r>=expand("%:p:h")<CR>
":vmap <leader>/ :RG <c-r>=expand("<cword>")<CR> FIXME
:nmap <leader>g/ :GG <c-r>=expand("<cword>")<CR><Space>
:nmap <leader>g? :GG <c-r>=expand("<cword>")<CR> <c-r>=expand("%:p:h")<CR>
" Previous buffer
:nmap <leader><Tab> <C-^>
nnoremap <F10> :call asyncrun#quickfix_toggle(8)<CR>
nnoremap <F5> :compiler gcc \| AsyncRun build -c lin.debug up-all<CR>
nnoremap <F6> :compiler gcc \| AsyncRun build -c lin.debug up-runtest<CR>

" Let * stay put! Toggle highlight to see the mark
:nmap <silent> * :let @/='\<'.expand('<cword>').'\>'<CR>:set hlsearch!<CR>:set hlsearch!<CR>

" Trigger omnifunction
:nmap <leader>o <c-x><c-o>

" Terminal window switching
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l
tnoremap <C-w>t <C-\><C-n><C-w>t
tnoremap <C-w>b <C-\><C-n><C-w>b
tnoremap <C-w>p <C-\><C-n><C-w>p

" Below interferes with FZF search results, where it is nice to just ESC out
" from the result list
"tnoremap <Esc> <C-\><C-n>

" Replace the word under cursor
nnoremap <leader>* :%s/\<<c-r><c-w>\>//g<left><left>
" Select a region and prepare a replace of a word
vnoremap <leader>* :s/\<\>//g<left><left><left><left><left>

" A more relaxed substitution than above, great for replacing a term already searched for, or manually filling it in
nnoremap <leader>s :%s///g<left><left><left>
vnoremap <leader>s :s///g<left><left><left>

" Since <leader>s was bound above, we need to find a new way to fix trailing whitespaces
vnoremap <leader>fw :StripWhitespace<CR>

" Trigger completions with Ctrl+SPC in insert mode
" Works in combination with 'set completefunc=<>'
inoremap <C-Space> <C-x><C-u>

" Simulate maximize/minimize window
nnoremap <C-w>m :call ToggleMiniMaxiWin()<CR>
nnoremap <leader>wm :call ToggleMiniMaxiWin()<CR>
nnoremap <leader>wd :q<CR>
nnoremap <C-w>d :q<CR>
function! ToggleMiniMaxiWin()
    if tabpagewinnr(tabpagenr(), '$') > 1
        tab split
    elseif tabpagenr('$') > 1
        if tabpagenr() < tabpagenr('$')
            tabclose
            tabprevious
        else
            tabclose
        endif
    endif
endfunction

" Visual select something that was pasted or edited
nnoremap gp `[v`]

" Refresh syntax
:nmap <leader>rs :syntax sync fromstart<CR>

" Toggle search-highlight
:nmap <leader><space> :set hlsearch!<CR>

" Show current highlight under cursor
nmap <leader>SP :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif

  " When editing python files, enable folding
  autocmd FileType python setlocal foldenable foldmethod=indent

  " Syntax on for ttcn
  autocmd BufRead,BufNewFile *.ttcn setfiletype ttcn
  autocmd BufRead,BufNewFile *.ttcnpp setfiletype ttcn
  autocmd BufRead,BufNewFile */jpacket/testsuites/*.txt set filetype=tcl

  " Label Jenkins files as groovy
  autocmd BufRead,BufNewFile Jenkinsfile* setfiletype groovy

  " vim.vim ft allows for tw=78, extend that to 120. Only affects comments as per 'formatoptions'
  autocmd BufRead,BufNewFile *.vim setlocal tw=120
  autocmd BufRead,BufNewFile *.md setlocal tw=120

  " Set the cursor to first line for git commit messages
  autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

  autocmd FileType c setlocal foldmethod=expr
  autocmd FileType c setlocal foldexpr=nvim_treesitter#foldexpr()

  autocmd FileType c vnoremap gq :LspFormat<CR>
  autocmd FileType cpp vnoremap gq :LspFormat<CR>
  autocmd FileType lua vnoremap gq :LspFormat<CR>
  autocmd FileType rust vnoremap gq :LspFormat<CR>
  " Poor man formatting... This will have to do for now
  autocmd FileType rust noremap gq :lua vim.lsp.buf.format()<CR>
  autocmd FileType go noremap gq :lua vim.lsp.buf.format()<CR>
  autocmd FileType markdown vnoremap <buffer> gq gq<CR>

  autocmd FileType c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType rust setlocal omnifunc=v:lua.vim.lsp.omnifunc

  " Since I am not a spelling bee
  " [s ]s Navigate
  " zg Add word to list
  " z= Spelling corrections, 1z= for fist suggestion
  " CTRL-X s to fix in insert-mode
  autocmd FileType gitcommit,text,cpp,c,h,vim,plantuml,yang,ttcn,yaml,python,cmake,markdown,fugitive,unix,help,sh,cfg,csh,lua,go,make setlocal spell spelllang=en_us

  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
  augroup END

endif

set mouse=

" Default fold level = Show everything
set foldlevel=200

" Should be syntax, but then setline() is superslow. Switching to manual, since we do not use folds anyways
" setline() is used by some formatters, so this can be syntax if the formatter is behaving
set foldmethod=syntax

set tabstop=4
set shiftround " when at 3 spaces, and I hit > ... Go to 4, not 5
set shiftwidth=4
set expandtab
set number
set noshowmode " Already handled by the statusline

set updatetime=100 " Default is 4s, but reduce it to make things more real time, like git gutter

set colorcolumn=121                 " Set the 120 character column
set cursorline                      " Highlight the current line
set hidden                          " Any buffer can be hidden
set relativenumber                  " To be cool like the kidz
set clipboard+=unnamedplus          " Copy-paste is the hardest thing we do

set inccommand=split " Live preview of subs

set splitbelow " When splitting horizontally place new window below
set splitright " when splitting vertically place new window to the right

" Smart pairs are disabled by default, let's try it
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" set shell=/bin/bash
set shell=fish

" Specify a directory for plugins
" " - For Neovim: ~/.local/share/nvim/plugged
" " - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
Plug 'neovim/nvim-lspconfig'
Plug 'ojroques/nvim-lspfuzzy'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'mtoohey31/cmp-fish'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/nvim-cmp'

Plug 'tpope/vim-sensible'             " Better than nocompat
Plug 'tpope/vim-commentary'           " Comment stuff with gc
Plug 'tpope/vim-speeddating'          " Ctrl-A / Ctrl-X more things
Plug 'machakann/vim-sandwich'         " Replacing tpope/vim-surround
Plug 'tpope/vim-unimpaired'           " More bindings for [ ]
Plug 'tpope/vim-fugitive'             " Need git
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-abolish'              " Super-Charged subst and search via :Subvert
Plug 'tpope/vim-eunuch'               " For the shebang filetype redetect and chmod+x
Plug 'tpope/vim-sleuth'               " For replacing need for tab settings
Plug 'ntpeters/vim-better-whitespace' " StripWhitespace for trailing spaces
Plug 'rebelot/kanagawa.nvim'          " colorsheme to use!
Plug 'junegunn/vim-easy-align'        " Align everything
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'          " Show the content of the registers
Plug 'nvim-lualine/lualine.nvim'      " The status line
Plug 'tmsvg/pear-tree'                " Replacing jiangmiao/auto-pairs
Plug 'moll/vim-bbye'                  " Bdelete and Bwipeout
Plug 'scrooloose/vim-slumlord'        " plantuml
Plug 'aklt/plantuml-syntax'           " plantuml
Plug 'nathanalderson/yang.vim'
Plug 'gen740/smoothcursor.nvim'

Plug 'Kypert/vim-clang-format', { 'branch': 'fix/issues/98' }
" Plug 'mhartington/formatter.nvim'
Plug 'Kypert/formatter.nvim', { 'branch': 'fix/45' }

Plug 'sakshamgupta05/vim-todo-highlight'
Plug 'rhysd/git-messenger.vim'
Plug 'rhysd/clever-f.vim'
Plug 'wellle/targets.vim'             " Add more targets, like aa (an argument)
Plug 'dense-analysis/ale'
Plug 'ericcurtin/CurtineIncSw.vim'    " Toggle header/src (C/C++)
Plug 'wsdjeg/vim-fetch'               " For file.ext:12:34
Plug 'skywind3000/asyncrun.vim'       " E.g. :AsyncRun build -c lin.debug up-all
Plug 'Konfekt/FastFold'               " Other plugins can depend on this, for example rhysd/vim-clang-format for faster
                                      " calls to setline() when using foldmethod=syntax
Plug 'chrisbra/unicode.vim'           " Search unicode chars
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'MTDL9/vim-log-highlighting'
Plug 'zchee/vim-flatbuffers'
Plug 'khaveesh/vim-fish-syntax'

Plug 'nvim-lua/plenary.nvim'

Plug 'jose-elias-alvarez/null-ls.nvim' " Need plenary and lspconfig

Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'vmware-archive/salt-vim'

Plug 'norcalli/nvim-colorizer.lua'

Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

Plug 'sindrets/diffview.nvim' " Need plenary

Plug 'vinnymeller/swagger-preview.nvim'
Plug 'JManch/sunset.nvim'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'lewis6991/gitsigns.nvim'
Plug 'shortcuts/no-neck-pain.nvim'

call plug#end()

" Consider nyngwang/murmur.lua
" In nvim 0.9, consider try splitkeep

" NOTE: Too much happening, revisit later once it has stabilize
" Plug 'shortcuts/no-neck-pain.nvim'

" NOTE: Somehow hides text when navigating the window layout
" Plug 'nvim-zh/colorful-winsep.nvim'

" NOTE: Treesitter not ready for 10k files yet.
" Plug 'haorenW1025/completion-nvim'
" Plug 'vigoux/completion-treesitter'

set wildoptions+=pum
set pumblend=20
set termguicolors

" Switching colorscheme, choirs:
" 1) Colorscheme itself
" 2) Status line
" 3) Terminal scheme
" 4) git diff (delta/bat)

" Normal color in popup window with 'CursorLine'
hi link gitmessengerPopupNormal CursorLine

" Header such as 'Commit:', 'Author:' with 'Statement' highlight group
hi link gitmessengerHeader Statement

" Commit hash at 'Commit:' header with 'Special' highlight group
hi link gitmessengerHash Special

" History number at 'History:' header with 'Title' highlight group
hi link gitmessengerHistory Title

let g:git_messenger_floating_win_opts = { 'border': 'single' }
let g:git_messenger_popup_content_margins = v:false

" To align definitions and then assignments: gad then ga=
" NOTE: This can still be useful, but nowadays just use the power of clang-format
if !exists('g:easy_align_delimiters')
  let g:easy_align_delimiters = {}
endif
let g:easy_align_delimiters['d'] = {
            \ 'pattern': ' \ze\S\+\s*[;=]',
            \ 'left_margin': 0, 'right_margin': 0
            \}

" Make RG able to take args like in the shell
" junegunn/fzf.vim/issues/419
command! -bang -nargs=* RG
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --with-filename --sort path ' . <q-args>, 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" GG as in Git grep, do not forget: CTRL-R CTRL-W for current word, same as CTRL-R=expand("<cword>")
command! -bang -nargs=* GG
  \ call fzf#vim#grep(
  \   'git grep --line-number -- ' . <q-args>, 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" Use preview globally, like in Buffers, Files. RG uses '?' to toggle it, since the search itself can be long
let g:fzf_preview_window = 'right:50%'

let g:ale_sign_column_always = 1
" Slow to start up C with below linters?
" let g:ale_linters = { 'c': ['clang', 'clangd', 'clangtidy', 'cppcheck', 'flawfinder', 'gcc'], 'python' : ['pylint'] }
let g:ale_linters = { 'python' : ['pylint', 'flake8', 'mypy'], 'sls' : ['salt-lint'] }
let g:ale_linters_explicit = 1
" Disable W1202 logging-format-interpolation
let g:ale_python_pylint_options = '--max-line-length=120 --disable=logging-format-interpolation --disable=logging-fstring-interpolation --disable=missing-function-docstring --function-rgx="[a-z_][a-z0-9_]{2,120}$" --method-rgx="[a-z_][a-z0-9_]{2,120}$"'
let g:ale_python_flake8_options = '--max-line-length=120'
" Set to never, in order to only lint on save, which is default
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_linter_aliases = { 'sls': 'salt' }

:packadd termdebug
let termdebugger = "gdb"
" Prevent termdebug to override mapping of K (which I want to keep mapped to LSP), use special mapping instead
let g:termdebug_map_K = 0
map <leader>k :Evaluate<CR>

" Enable undo persistence (remember to clean it manually from time to time!)
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir", "", 0700)
endif
set undodir=~/.vim/undodir
set undofile

" Open quickfix window with a fixed lines of height
let g:asyncrun_open = 8

let g:todo_highlight_config = { 'NOTE': {} }

" Add git to the blacklist, similar to diff, when showing a commit in fugitive
let g:better_whitespace_filetypes_blacklist=['git', 'diff', 'gitcommit', 'unite', 'qf', 'help',] " 'markdown']

let g:sls_use_jinja_syntax = 1

" nvim-cmp says to include this
set completeopt=menu,menuone,noselect

" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

luafile $HOME/.config/nvim/nvim_init.lua
