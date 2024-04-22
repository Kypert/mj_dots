set listchars=tab:>\ ,trail:-,eol:$ " Gets overwritten to something default if set in lua (0.9.5)

" Specify a directory for plugins
" " - For Neovim: ~/.local/share/nvim/plugged
" " - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
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
Plug 'tpope/vim-commentary'           " Comment stuff with gc TODO: can be removed in nvim 0.10.0
Plug 'tpope/vim-speeddating'          " Ctrl-A / Ctrl-X more things
Plug 'tpope/vim-fugitive'             " Need git
Plug 'tpope/vim-repeat'
Plug 'tummetott/unimpaired.nvim'
Plug 'tpope/vim-abolish'              " Super-Charged subst and search via :Subvert
Plug 'tpope/vim-eunuch'               " For the shebang filetype redetect and chmod+x
Plug 'tpope/vim-sleuth'               " For replacing need for tab settings
Plug 'ntpeters/vim-better-whitespace' " StripWhitespace for trailing spaces
Plug 'rebelot/kanagawa.nvim'          " colorsheme to use!
Plug 'junegunn/vim-easy-align'        " Align everything
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-lualine/lualine.nvim'      " The status line
Plug 'altermo/ultimate-autopair.nvim', { 'branch': 'v0.6' }
Plug 'moll/vim-bbye'                  " Bdelete and Bwipeout
Plug 'nathanalderson/yang.vim'
Plug 'gen740/smoothcursor.nvim'

Plug 'rhysd/git-messenger.vim'
Plug 'wellle/targets.vim'             " Add more targets, like aa (conflicts with treesitter)
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'RRethy/nvim-treesitter-endwise'
Plug 'MTDL9/vim-log-highlighting'

Plug 'nvim-lua/plenary.nvim'

Plug 'stevearc/conform.nvim'
Plug 'mfussenegger/nvim-lint'

Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'vmware-archive/salt-vim'

Plug 'NvChad/nvim-colorizer.lua'

Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

Plug 'sindrets/diffview.nvim' " Need plenary

Plug 'vinnymeller/swagger-preview.nvim'
Plug 'JManch/sunset.nvim'

Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'} " Try native snippets in 0.10.0
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'lewis6991/gitsigns.nvim'
Plug 'shortcuts/no-neck-pain.nvim'

Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo'

Plug 'j-hui/fidget.nvim' " Extensible UI for Neovim notifications and LSP progress messages
Plug 'tzachar/highlight-undo.nvim'
Plug 'kylechui/nvim-surround'
Plug 'MeanderingProgrammer/markdown.nvim'
Plug 'folke/which-key.nvim'
Plug 'folke/flash.nvim'
Plug 'gczcn/antonym.nvim' " Toggle with <leader>ta
Plug 'andrewferrier/debugprint.nvim'
call plug#end()

" Consider nyngwang/murmur.lua or RRethy/vim-illuminate for cursor word highlight
" Consider linrongbin16/fzfx.nvim or ibhagwan/fzf-lua instead of junegunn/fzf.vim

luafile $HOME/.config/nvim/nvim_init.lua
