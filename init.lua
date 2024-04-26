-- For debugging, print anything
function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

-- {{{ Plugins
-- Consider nyngwang/murmur.lua or RRethy/vim-illuminate for cursor word highlight
-- Consider linrongbin16/fzfx.nvim or ibhagwan/fzf-lua instead of junegunn/fzf.vim
local Plug = vim.fn['plug#']
vim.call('plug#begin') -- Neovim: stdpath('data') . '/plugged' = (~/.local.share/nvim/plugged)

Plug('neovim/nvim-lspconfig')
Plug('ojroques/nvim-lspfuzzy')

Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('mtoohey31/cmp-fish')
Plug('hrsh7th/cmp-nvim-lua')
Plug('hrsh7th/cmp-nvim-lsp-signature-help')
Plug('hrsh7th/nvim-cmp')

Plug('tpope/vim-speeddating')          -- Ctrl-A / Ctrl-X more things
Plug('tpope/vim-fugitive')             -- Need git
Plug('tpope/vim-repeat')
Plug('tummetott/unimpaired.nvim')
Plug('tpope/vim-abolish')              -- Super-Charged subst and search via :Subvert
Plug('tpope/vim-eunuch')               -- For the shebang filetype redetect and chmod+x
Plug('tpope/vim-sleuth')               -- For replacing need for tab settings
Plug('ntpeters/vim-better-whitespace') -- StripWhitespace for trailing spaces
Plug('rebelot/kanagawa.nvim')          -- colorsheme to use!
Plug('junegunn/vim-easy-align')        -- Align everything
Plug('junegunn/fzf', { ['do'] = function() vim.fn('fzf#install()') end })
Plug('junegunn/fzf.vim')
Plug('nvim-lualine/lualine.nvim')      -- The status line
Plug('altermo/ultimate-autopair.nvim', { ['branch'] = 'v0.6' })
Plug('moll/vim-bbye')                  -- Bdelete and Bwipeout
Plug('nathanalderson/yang.vim')
Plug('gen740/smoothcursor.nvim')

Plug('rhysd/git-messenger.vim')
Plug('wellle/targets.vim')             -- Add more targets, like aa (conflicts with treesitter)
Plug('nvim-treesitter/nvim-treesitter')
Plug('nvim-treesitter/nvim-treesitter-refactor')
Plug('nvim-treesitter/nvim-treesitter-textobjects')
Plug('RRethy/nvim-treesitter-endwise')
Plug('MTDL9/vim-log-highlighting')

Plug('nvim-lua/plenary.nvim')

Plug('stevearc/conform.nvim')
Plug('mfussenegger/nvim-lint')

Plug('Glench/Vim-Jinja2-Syntax')
Plug('vmware-archive/salt-vim')

Plug('NvChad/nvim-colorizer.lua')

Plug('https://git.sr.ht/~whynothugo/lsp_lines.nvim')

Plug('sindrets/diffview.nvim') -- Need plenary

Plug('vinnymeller/swagger-preview.nvim')
Plug('JManch/sunset.nvim')

Plug('L3MON4D3/LuaSnip', {['tag'] = 'v2.*', ['do'] = 'make install_jsregexp'}) -- Try native snippets in 0.10.0
Plug('saadparwaiz1/cmp_luasnip')
Plug('rafamadriz/friendly-snippets')

Plug('lewis6991/gitsigns.nvim')
Plug('shortcuts/no-neck-pain.nvim')

Plug('kevinhwang91/promise-async')
Plug('kevinhwang91/nvim-ufo')

Plug('j-hui/fidget.nvim') -- Extensible UI for Neovim notifications and LSP progress messages
Plug('tzachar/highlight-undo.nvim')
Plug('kylechui/nvim-surround')
Plug('MeanderingProgrammer/markdown.nvim')
Plug('folke/which-key.nvim')
Plug('folke/flash.nvim')
Plug('gczcn/antonym.nvim') -- Toggle with <leader>ta
Plug('andrewferrier/debugprint.nvim')
vim.call('plug#end')
-- }}}

-- {{{ Globals and general options
-- Use preview globally, like in Buffers, Files. RG uses '?' to toggle it, since the search itself can be long
vim.g.fzf_preview_window = 'right:50%'

-- Make RG able to take args like in the shell
-- junegunn/fzf.vim/issues/419
vim.cmd([[command! -bang -nargs=* RG
  \ call fzf#vim#grep(
  \     "rg --column --line-number --no-heading --color=always --smart-case --with-filename --sort path " . <q-args>, 1,
  \     <bang>0 ? fzf#vim#with_preview("up:60%")
  \             : fzf#vim#with_preview("right:50%:hidden", "?"),
  \     <bang>0)
]])

-- GG as in Git grep, do not forget: CTRL-R CTRL-W for current word, same as CTRL-R=expand("<cword>")
vim.cmd([[command! -bang -nargs=* GG
  \ call fzf#vim#grep(
  \   'git grep --line-number -- ' . <q-args>, 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
]])

vim.g.sls_use_jinja_syntax = 1

-- Add git to the blacklist, similar to diff, when showing a commit in fugitive
vim.g.better_whitespace_filetypes_blacklist = {
    'git', 'diff', 'gitcommit', 'unite', 'qf', 'help', -- 'markdown'
}

-- Enable undo persistence (remember to clean it manually from time to time!)
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(vim.o.undodir, "p")

vim.o.pumblend = 20
vim.o.termguicolors = true
vim.o.shell = 'fish'
vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.showmode = false -- Already handled by the statusline
vim.o.cursorline = true
vim.o.relativenumber = true
vim.o.colorcolumn = '121'
vim.o.inccommand = 'split' -- Live preview of subs
vim.o.mouse = ''
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.smoothscroll = true
vim.o.scrolloff = 1     -- from vim-sensible
vim.o.sidescroll = 1    -- from vim-sensible
vim.o.sidescrolloff = 2 -- from vim-sensible
vim.o.updatetime = 100  -- Default is 4s, but reduce it to make things more real time, like git gutter

vim.o.listchars = "tab:> ,trail:-,eol:$"
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.shiftround = true -- When at 3 spaces, and I hit > ... Go to 4, not 5

vim.o.clipboard = "unnamedplus,unnamed"

-- Since I use neovim from build directly, gain (all) syntax for vim for example
vim.o.rtp = vim.o.rtp .. ",~/proj/neovim/build/runtime"

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' } -- nvim-cmp says to include this


-- OSC 52, in neovim nightly, but maybe slow?
-- vim.g.clipboard = {
-- 	name = 'OSC 52',
-- 	copy = {
-- 		['+'] = require('vim.ui.clipboard.osc52').copy,
-- 		['*'] = require('vim.ui.clipboard.osc52').copy,
-- 	},
-- 	paste = {
-- 		['+'] = require('vim.ui.clipboard.osc52').paste,
-- 		['*'] = require('vim.ui.clipboard.osc52').paste,
-- 	},
-- }

-- }}}

-- {{{ General key mappings
-- Check for conflicts with `checkhealth which-key`
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>fs', "<cmd>w<cr>", { desc = 'Save' })
vim.keymap.set('n', '<leader>ff', "<cmd>Files %:p:h<cr>", { desc = 'File explore now' })
vim.keymap.set('n', '<leader>fF', ':Files <c-r>=expand("%:p:h")<CR>', { desc = 'File explore path' })
vim.keymap.set('n', '<leader>fg', ':GFiles <c-r>=expand("%:p:h")<CR><CR>', { desc = 'File (git) explore path now' })
vim.keymap.set('n', '<leader>fG', ':GFiles <c-r>=expand("%:p:h")<CR>', { desc = 'File (git) explore path' })

vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>', { desc = 'Git status' })

vim.keymap.set('n', '<leader>bb', '<cmd>Buffers<cr>', { desc = 'List buffers' })
vim.keymap.set('n', '<leader>bd', '<cmd>Bdelete<cr>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bD', '<cmd>Bwipeout<cr>', { desc = 'Delete buffer!' })
vim.keymap.set('n', '<leader><tab>', '<C-^>', { desc = 'Previous buffer' })

vim.keymap.set('n', '<leader>/', ':RG <c-r>=expand("<cword>")<cr><space>', { desc = 'rg cword' })
vim.keymap.set('n', '<leader>?', ':RG <c-r>=expand("<cword>")<cr> <c-r>=expand("%:p:h")<cr>',
    { desc = 'rg cword path' })
vim.keymap.set('v', '<leader>/', '"vy:<c-w>RG "<c-r>v"<space>', { desc = 'rg selection (claiming "v)' })
vim.keymap.set('v', '<leader>?', '"vy:<c-w>RG "<c-r>v" <c-r>=expand("%:p:h")<cr>',
    { desc = 'rg selection path (claiming "v)' })
vim.keymap.set('n', '<leader>g/', ':GG <c-r>=expand("<cword>")<cr><space>', { desc = 'git grep cword' })
vim.keymap.set('n', '<leader>g?', ':GG <c-r>=expand("<cword>")<cr> <c-r>=expand("%:p:h")<cr>',
    { desc = 'git grep cword path' })

vim.keymap.set('n', '<leader>qq', "<cmd>q<cr>", { desc = 'Quit' })
vim.keymap.set('n', '<leader>qa', "<cmd>qa<cr>", { desc = 'Quit all' })
vim.keymap.set('n', '<leader>qa!', "<cmd>qa!<cr>", { desc = 'Quit all!' })
vim.keymap.set('n', '<leader>q!', "<cmd>qa!<cr>", { desc = 'Quit!' })

vim.keymap.set('n', '<leader>wd', "<cmd>q<cr>", { desc = 'Close win' })
vim.keymap.set('n', '<C-w>d', "<cmd>q<cr>", { desc = 'Close win' })

-- Simulate maximize/minimize window
function ToggleMiniMaxiWin()
    if vim.fn.tabpagewinnr(vim.fn.tabpagenr(), '$') > 1 then
        -- Does this tab has more than 1 window? Then split the current window to a new tab, to simulate a zoom
        vim.cmd("tab split")
    elseif vim.fn.tabpagenr('$') > 1 then
        -- Ok, so we want to restore the zoom, which we can do if we have more than 1 tab, otherwise it is already good
        if vim.fn.tabpagenr() < vim.fn.tabpagenr('$') then
            -- Our tab is not the last one
            vim.cmd("tabclose")
            vim.cmd("tabprevious")
        else
            vim.cmd("tabclose")
        end
    end
end
vim.keymap.set('n', '<C-w>m', ToggleMiniMaxiWin, { desc = 'Mini/maxi win' })
vim.keymap.set('n', '<leader>wm', ToggleMiniMaxiWin, { desc = 'Mini/maxi win' })

vim.keymap.set('n', '<leader>tr', "<cmd>syntax sync fromstart<cr>", { desc = 'Trigger manual syntax sync' })
vim.keymap.set('n', '<leader>ts', "<cmd>set hlsearch!<cr>", { desc = 'Toggle search highlight' })
vim.keymap.set({'n', 'v'}, '<leader>tw', ":StripWhitespace<cr>", { desc = 'Trigger fixing whitespaces' })

-- Template subs, great for replacing a term already searched for, or manually filling it in
vim.keymap.set('n', '<leader>ss', ":%s///g<left><left><left>", { desc = 'Sub ready to go' })
vim.keymap.set('v', '<leader>ss', ":s///g<left><left><left>", { desc = 'Sub ready to go' })

vim.keymap.set('n', 'gp', "`[v`]", { desc = 'Visual select pasted or edited' })

function ToggleSignCcNum()
    vim.o.signcolumn = vim.o.signcolumn == 'yes' and 'no' or 'yes'
    vim.o.relativenumber = not vim.o.relativenumber
    vim.o.number = not vim.o.number
    vim.o.colorcolumn = vim.o.colorcolumn == '0' and '121' or '0'
end
vim.keymap.set('n', '<c-n><c-n>', ToggleSignCcNum, { desc = 'Toggle Sign Cc Num columns', noremap = true })

-- Toggle hlsearch to see the mark
vim.keymap.set('n', '*', "<cmd>let @/='\\<'.expand('<cword>').'\\>'<cr><cmd>set hlsearch!<cr><cmd>set hlsearch!<cr>",
    { desc = '* but stay put' })
vim.keymap.set('n', '<leader>*', ":%s/\\<<c-r><c-w>\\>//g<left><left>", { desc = 'Replace the word under cursor' })
vim.keymap.set('v', '<leader>*', ":s/\\<\\>//g<left><left><left><left><left>",
    { desc = 'Select a region and prepare a replace of a word' })

-- vim.keymap.set('i', '<C-space>', '<c-x><c-o>', { desc = 'Trigger omnifunc' })
vim.keymap.set('i', '<C-space>', '<c-x><c-u>', { desc = 'Trigger completefunc' })

-- Terminal window switching
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', { desc = 'Win go left' })
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', { desc = 'Win go down' })
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', { desc = 'Win go up' })
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', { desc = 'Win go right' })
vim.keymap.set('t', '<C-w>b', '<C-\\><C-n><C-w>b', { desc = 'Win go bottom' })
vim.keymap.set('t', '<C-w>t', '<C-\\><C-n><C-w>t', { desc = 'Win go top' })
vim.keymap.set('t', '<C-w>p', '<C-\\><C-n><C-w>p', { desc = 'Win go prev' })
-- Below interferes with FZF search results, where it is nice to just ESC out from the result list
--tnoremap <Esc> <C-\><C-n>

vim.keymap.set({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)', { desc = 'EasyAlign (vipga / gaip)', noremap = true })
-- }}}

-- {{{ termdebug
vim.cmd('packadd termdebug')
vim.g.termdebug_config = {}
vim.g.termdebug_config['command'] = "gdb"
vim.g.termdebug_config['map_K'] = 0
vim.keymap.set('n', '<leader>k', '<cmd>Evaluate<cr>', { desc = 'Termdebug evaluate', noremap = true })
-- }}}

-- {{{ General autocmds
vim.api.nvim_create_autocmd('BufReadPost', {
    desc = "When editing a file, always jump to the last cursor position",
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line('$') then
            vim.cmd('normal! g`"')
        end
    end
})

vim.api.nvim_create_autocmd('BufEnter', {
    desc = "Set the cursor to first line for git commit messages",
    pattern = { '*.git/COMMIT_EDITMSG' },
    callback = function() vim.cmd('normal! gg0') end
})

vim.api.nvim_create_autocmd('FileType', {
    desc = "vim.vim ft allows for tw=78, extend that to 120. Only affects comments as per 'formatoptions'",
    pattern = { 'vim', 'markdown' },
    callback = function(ev) vim.bo[ev.buf].textwidth = 120 end
})

vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    desc = "Label Jenkins files as groovy",
    pattern = { 'Jenkinsfile' },
    callback = function() vim.o.filetype = 'groovy' end
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})

-- Since I am not a spelling bee
-- [s ]s Navigate
-- zg Add word to list
-- z= Spelling corrections, 1z= for fist suggestion
-- CTRL-X s to fix in insert-mode
vim.api.nvim_create_autocmd('FileType', {
    pattern = { -- Hmm, what is better, to list all I want or skip the ones I do not (popups)?
        'gitcommit', 'text', 'cpp', 'c', 'h', 'vim', 'yang', 'ttcn', 'yaml', 'python', 'cmake', 'markdown',
        'fugitive', 'unix', 'help', 'sh', 'cfg', 'csh', 'lua', 'go', 'make', 'sls', 'salt', 'fish'
    },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
    end
})

-- }}}

-- {{{ treesitter
require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    refactor = {
        -- highlight_definitions = {
        --     enable = true
        -- },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = 'gd',
                goto_next_usage = '<a-*>',
                goto_previous_usage = '<a-#>',
            },
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['aa'] = { query = '@parameter.outer', desc = 'an argument' },
                ['ia'] = { query = '@parameter.inner', desc = 'inner part of an argument' },
                ['af'] = { query = '@function.outer', desc = 'a function region' },
                ['if'] = { query = '@function.inner', desc = 'inner part of a function region' },
                ['al'] = { query = '@loop.outer', desc = 'a loop' },
                ['il'] = { query = '@loop.inner', desc = 'inner part of a loop' },
            },
        },
    },
    endwise = {
        enable = true,
    },
})
-- }}}

-- {{{ LSP
local lspconfig = require('lspconfig')

vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Open diagnostics popup' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostics' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostics' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open loc list with diagnostics' })

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local function map(mode, l, r, desc)
            local opts = {
                buffer = ev.buf,
                desc = desc,
            }
            vim.keymap.set(mode, l, r, opts)
        end

        map('n', '<leader>gD', vim.lsp.buf.declaration, 'Go declaration')
        map('n', '<leader>gd', vim.lsp.buf.definition, 'Go definition')
        map('n', '<leader>gi', vim.lsp.buf.implementation, 'Go implemntation')
        map('n', '<leader>gn', vim.lsp.buf.rename, 'Rename')
        map('n', '<leader>ga', vim.lsp.buf.code_action, 'Code action')
        map('n', '<leader>gr', vim.lsp.buf.references, 'Go references')
        map('n', 'K', vim.lsp.buf.hover, 'Hover')
        map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')

        -- vim.cmd('syntax on') -- Do I need this? It was for spelling to skip keywords and variable names
    end,
})

lspconfig.clangd.setup({
    cmd = {
        -- Set this via `pick_compile_command`
        'clangd',
        '--offset-encoding=utf-16',
        '--compile-commands-dir=' .. (os.getenv('COMPILE_COMMANDS_DIR') and os.getenv('COMPILE_COMMANDS_DIR') or '.'),
    },
})

lspconfig.rust_analyzer.setup({
    cmd = {
        'rust-analyzer',
    },
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        ['rust-analyzer'] = {
            assist = {
                importGranularity = 'module',
                importPrefix = 'by_self',
            },
            cargo = {
                loadOutDirsFromCheck = true,
            },
            checkOnSave = {
                command = 'clippy',
            },
            diagnostics = {
                disabled = { 'unresolved-import' },
            },
            procMacro = {
                enable = true,
            },
        },
    },
})

lspconfig.gopls.setup({
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            buildFlags = {
                "-tags=testft",
            },
        },
    },
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- lspconfig.salt_ls.setup({
-- })

-- lspconfig.jedi_language_server.setup({
--     cmd = {
--         'jedi-language-server',
--     },
-- })

lspconfig.basedpyright.setup({
    settings = {
        basedpyright = {
            typeCheckingMode = "standard", -- default is all, pretty based
        }
    }

})

lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                    quote_style = "single",
                }
            },
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
            telemetry = {
                enabled = false
            }
        }
    },
}

-- But how to filter in the result in this one?
require('lspfuzzy').setup({
    fzf_preview = {
        'right:+{2}-/2',
    },
})
-- }}}

-- {{{ Formatting
-- Use conform for gq
vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
require("conform").setup({
    formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        go = { "goimports", "golines" }, -- sequential
        python = { "yapf", "ruff" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
    }
})

require('conform').formatters.golines = {
    prepend_args = { '--max-len', '120', '--shorten-comments' },
}

require('conform').formatters.shfmt = {
    prepend_args = { '--indent', '4' },
}
--- }}}

-- {{{ Linting
require('lint').linters_by_ft = {
    bash = { 'shellcheck' },
    go = { 'golangcilint' },
    -- lua = { 'selene' },
    python = { 'ruff', 'flake8', 'pylint', 'mypy' },
    sh = { 'shellcheck' },
    sls = { 'saltlint' },
}

local flake8 = require('lint').linters.flake8
table.insert(flake8.args, 1, '--max-line-length=120')

local pylint = require('lint').linters.pylint
pylint.args = {
    '--max-line-length=120',
    '--disable=logging-format-interpolation',
    '--disable=logging-fstring-interpolation',
    '--disable=missing-function-docstring',
    '--function-rgx=[a-z_][a-z0-9_]{2,120}$',
    '--method-rgx=[a-z_][a-z0-9_]{2,120}$',
    '--variable-rgx=[a-z_][a-z0-9_]{0,30}$',
    '--argument-rgx=[a-z_][a-z0-9_]{0,30}$',
    '--attr-rgx=[a-z_][a-z0-9_]{0,30}$',
    unpack(pylint.args),
}

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    callback = function()
        require('lint').try_lint()
    end,
})
--- }}}

-- {{{ Folding
vim.o.foldcolumn = '0'
vim.o.foldlevelstart = 99
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

local ufo_handler = function(text, lnum, endLnum, width)
      local suffix = "  "
      local lines  = ('[%d lines] '):format(endLnum - lnum)

      local cur_width = 0
      for _, section in ipairs(text) do
        cur_width = cur_width + vim.fn.strdisplaywidth(section[1])
      end

      suffix = suffix .. (' '):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 3)

      table.insert(text, { suffix, 'Comment' })
      table.insert(text, { lines, 'Todo' })
      return text
end

require('ufo').setup({
    open_fold_hl_timeout = 0,
    fold_virt_text_handler = ufo_handler,
    provider_selector = function()
        return {'treesitter', 'indent'}
    end
})
--- }}}

-- {{{ Colorscheme

require('kanagawa').setup({
    transparent = false,
    dimInactive = true,
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none"
                }
            }
        }
    },
    overrides = function()
        return {
            ["@comment.todo.comment"] = { link = "@comment.note" }, -- rebelot/kanagawa.nvim/issues/197
        }
    end,
})

vim.cmd('colorscheme kanagawa')
vim.api.nvim_create_user_command('GoLight', function(_)
    vim.cmd('set background=light')
    vim.cmd("let $BAT_THEME='Kanagawa Lotus Light'")
    vim.cmd("let $FZF_DEFAULT_OPTS='--color=light'")
    vim.cmd('highlight link GitSignsCurrentLineBlame TabLine')
end, {})
vim.api.nvim_create_user_command('GoDark', function(_)
    vim.cmd('set background=dark')
    vim.cmd("let $BAT_THEME='Kanagawa Wave'")
    vim.cmd("let $FZF_DEFAULT_OPTS='--color=dark'")
    vim.cmd('highlight link GitSignsCurrentLineBlame TabLine')
end, {})

local f = io.open('/tmp/term_bg_color', 'r')
if f then
    local first_line = io.lines('/tmp/term_bg_color')()
    if string.find(first_line, 'light') then
        vim.cmd('GoLight')
    else
        vim.cmd('GoDark')
    end
else
    vim.cmd('GoDark')
end
f.close()

require('sunset').setup({
    -- Gothenburg
    latitude = 57.7089,
    longitude = 11.9746,
    -- Shanghai
    -- latitude = 32.450166,
    -- longitude = 120.388640,
    day_callback = function() vim.cmd('GoLight') end,
    night_callback = function() vim.cmd('GoDark') end,
})

--- }}}

-- {{{ Snippets
local luasnip = require('luasnip')
local cmp = require('cmp')
cmp.setup({
    enabled = function()
        -- Disable completion in comments
        -- local context = require('cmp.config.context')
        -- Keep command mode completion enabled when cursor is in a comment
        -- if vim.api.nvim_get_mode().mode == 'c' then
        --     return true
        -- else
        --     return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
        -- end
        return true
    end,
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

        -- For snippets
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.snippet.jumpable(1) then
                vim.snippet.jump(1)
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.snippet.jumpable(-1) then
                vim.snippet.jump(-1)
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'fish' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    }),
})

local ls = require('luasnip.loaders.from_vscode')
ls.lazy_load()
-- vim.keymap.set({ 'i' }, '<c-K>', function() ls.expand() end, { silent = true })
-- vim.keymap.set({ 'i', 's' }, '<c-L>', function() ls.jump(1) end, { silent = true })
-- vim.keymap.set({ 'i', 's' }, '<c-J>', function() ls.jump(-1) end, { silent = true })
-- vim.keymap.set({ 'i', 's' }, '<c-E>', function()
--     if ls.choice_active() then
--         ls.change_choice(1)
--     end
-- end, { silent = true })

local unlinkgrp = vim.api.nvim_create_augroup('UnlinkSnippetOnModeChange', { clear = true })
vim.api.nvim_create_autocmd('ModeChanged', {
    group = unlinkgrp,
    pattern = { 's:n', 'i:*' },
    desc = 'Forget the current snippet when leaving the insert mode (L3MON4D3/LuaSnip/issues/656)',
    callback = function(evt)
        if luasnip.session and luasnip.session.current_nodes[evt.buf] and not luasnip.session.jump_active then
            luasnip.unlink_current()
        end
    end,
})
--- }}}

require('lualine').setup()

require('smoothcursor').setup({
    cursor = '',
    fancy = {
        enable = true,
        head = { cursor = '', texthl = 'SmoothCursor', linehl = nil },
    },
    disabled_filetypes = {'fzf', 'gitmessengerpopup', ''},
    max_threshold = 120
})

require('colorizer').setup()
vim.keymap.set('', '<leader>tc', "<cmd>ColorizerToggle<cr>", { desc = 'Toggle colorizer' })

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
    -- Check https://todo.sr.ht/~whynothugo/lsp_lines.nvim/5
    virtual_text = false,

    float = {
        border = 'rounded',
        source = true, -- Which is good for filetypes that can have multiple linters
    },
})
vim.keymap.set('', '<leader>dt', require('lsp_lines').toggle, { desc = 'Toggle diagnostics' })
require('lsp_lines').setup()

require('diffview').setup({
    use_icons = false,
})

require('gitsigns').setup({
    numhl = true,
    current_line_blame = false,
    current_line_blame_opts = {
        virt_text_pos = 'right_align',
        delay = 200,
    },
    current_line_blame_formatter = ' <abbrev_sha>/<author>, <committer_time:%Y-%m-%d %X> - <summary>',
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, desc)
            local opts = {
                buffer = bufnr,
                desc = desc,
            }
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
            else
                gitsigns.nav_hunk('next', { navigation_message = true, wrap = false })
            end
        end, "Next git hunk")

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({'[c', bang = true})
            else
                gitsigns.nav_hunk('prev', { navigation_message = true, wrap = false })
            end
        end, "Prev git hunk")

        -- Actions
        map('n', '<leader>ghs', gitsigns.stage_hunk, 'Stage hunk')
        map('n', '<leader>ghr', gitsigns.reset_hunk, 'Reset hunk')
        map('v', '<leader>ghs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Stage hunk')
        map('v', '<leader>ghr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Reset hunk')
        map('n', '<leader>ghS', gitsigns.stage_buffer, 'Stage buffer')
        map('n', '<leader>ghu', gitsigns.undo_stage_hunk, 'Unstage hunk')
        map('n', '<leader>ghR', gitsigns.reset_buffer, 'Reset buffer')
        map('n', '<leader>ghp', gitsigns.preview_hunk, 'Preview hunk')
        -- TODO Replace git-messenger with gitsignsblame_line()? But the info and layout is not as great (yet)?
        map('n', '<leader>gb', function() gitsigns.blame_line({ full = true }) end, 'Hunk blame')
        map('n', '<leader>ghd', gitsigns.diffthis, 'Hunk diff file')
        map('n', '<leader>ghD', function() gitsigns.diffthis('~') end, 'Diff with ~')
        map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, 'Toggle line blame')
        map('n', '<leader>gtd', gitsigns.toggle_deleted, 'Toggle deleted lines')

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select hunk')
    end,
})

require("no-neck-pain").setup({
    autocmds = {
        enableOnVimEnter = true,
    },
    width = 160,
})

require('fidget').setup({})

require('highlight-undo').setup({})

require('render-markdown').setup({})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown' },
    callback = function(ev)
        vim.keymap.set('n', '<leader>md', require('render-markdown').toggle,
            { buffer = ev.buf, desc = 'Toggle md rendering' })
    end
})

local wk = require('which-key') -- :checkhealth which-key
wk.register({
    ['<leader>t'] = { name = '+Toggle/Trigger' },
    ['<leader>s'] = { name = '+Search' },
    ['<leader>q'] = { name = '+Quit' },
    ['<leader>w'] = { name = '+Window' },
    ['<leader>f'] = { name = '+File' },
    ['<leader>g'] = { name = '+Git' },
    ['<leader>gh'] = { name = '+Hunks' }, -- ? Does not show up
    ['<leader>gt'] = { name = '+Toggle' }, -- ? Does not show up
    ['<leader>d'] = { name = '+Diagnostics' },
    ['<leader>b'] = { name = '+Buffer' },
}, { mode = { 'n', 'v', 'x', 'o' } })
vim.o.timeout = true
vim.o.timeoutlen = 300

require('nvim-surround').setup({})
require('flash').setup({})
-- ; and , to adjust the scope
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>st', function() require('flash').treesitter() end,
    { desc = 'Flash Treesitter Selection' })
vim.keymap.set('n', '<leader>tf', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, {desc = "Toggle Flash Search"})

require('ultimate-autopair').setup({})

require('antonym').setup({})
vim.keymap.set('n', '<leader>ta', '<cmd>AntonymWord<CR>', {desc = "Toggle antonym word"})

require('unimpaired').setup({})
wk.register({
    ['yo'] = { name = '+Toggle options' },
    [']o'] = { name = '+Disable options' },
    ['[o'] = { name = '+Enable options' },
}, { mode = 'n' })

require('debugprint').setup({
    print_tag = "OPENBAR",
})
wk.register({
    ['g?'] = { name = '+debugprint' },
}, { mode = {'n', 'v'} })

-- Default marker {{{ }}}
-- vim: foldmethod=marker foldlevel=0
