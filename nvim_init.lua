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

-- {{{ treesitter
require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'grr', -- As in 'very angry'!
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grN',
        },
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
        enable = true,
        select = {
            enable = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['aC'] = '@class.outer',
                ['iC'] = '@class.inner',
                ['ac'] = '@conditional.outer',
                ['ic'] = '@conditional.inner',
                ['ab'] = '@block.outer',
                ['ib'] = '@block.inner',
                ['al'] = '@loop.outer',
                ['il'] = '@loop.inner',
                ['is'] = '@statement.inner',
                ['as'] = '@statement.outer',
                ['am'] = '@call.outer',
                ['im'] = '@call.inner',
                ['ad'] = '@comment.outer',
                ['aa'] = '@parameter.inner', -- Works, but still not perfect, still leaves the separator (if any)
            },
        },
    },
})
-- }}}

local lspconfig = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Let null-ls handle the formatting
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('formatexpr', 'v:lua.vim.lsp.formatexpr()')
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    buf_set_option('tagfunc', 'v:lua.vim.lsp.tagfunc')

    -- Mappings
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    -- buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- lspconfig.ccls.setup {
--     cmd = {
--         'ccls', '--log-file=/tmp/' .. os.getenv('USER') .. '/cc.log'
--     },
--     init_options = {
--         cache = {
--             directory = '/tmp/' .. os.getenv('USER') .. '/ccls';
--         },
--         -- Set this via `pick_compile_command`
--         compilationDatabaseDirectory = os.getenv("COMPILE_COMMANDS_DIR"),
--         index = {
--             initialBlacklist = {
--                 "./application",
--                 "./framework",
--                 "./toolbox",
--                 "./tools",
--                 "./up/dp/cdpi-main"
--             };
--             -- initialBlacklist = {"."};
--         },
--     },
--     on_attach = on_attach,
--     flags = {
--       debounce_text_changes = 150,
--     },
-- }

lspconfig.clangd.setup({
    cmd = {
        -- Set this via `pick_compile_command`
        'clangd',
        '--offset-encoding=utf-16',
        '--compile-commands-dir=' .. (os.getenv('COMPILE_COMMANDS_DIR') and os.getenv('COMPILE_COMMANDS_DIR') or '.'),
    },
    on_attach = on_attach,
})

lspconfig.rust_analyzer.setup({
    cmd = {
        'rust-analyzer',
    },
    on_attach = on_attach,
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

util = require('lspconfig/util')

lspconfig.gopls.setup({
    cmd = { 'gopls', 'serve' },
    on_attach = on_attach,
    filetypes = { 'go', 'gomod' },
    root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

lspconfig.salt_ls.setup({
    on_attach = on_attach,
})

lspconfig.jedi_language_server.setup({
    cmd = {
        'jedi-language-server',
    },
    on_attach = on_attach,
})

-- But how to filter in the result in this one?
require('lspfuzzy').setup({
    fzf_preview = {
        'right:+{2}-/2',
    },
})

function formatter_rust()
    return {
        -- Need nightly to get the per lines feature
        exe = os.getenv('HOME') .. '/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rustfmt',
        args = {
            '--emit=files',
            '--unstable-features',
            '--file-lines',
            '\'[{"file":"$tempfile","range":[$start_line,$end_line]}]\'',
        },
        stdin = false,
        cwd = vim.fn.getcwd(),
        tempfile_inline = true,
        range_lines_one_based = true,
    }
end
require('formatter').setup({
    filetype = {
        -- c = { formatter_clang_format },
        -- cpp = { formatter_clang_format },
        -- rust = { formatter_rust },
    },
})

local null_ls = require('null-ls')
null_ls.setup({
    -- debug = true,
    cmd = { os.getenv('HOME') .. '/proj/neovim/build/bin/nvim' },
    on_attach = function()
        -- vim.cmd([[ command! -nargs=0 -range LspFormat execute 'lua vim.lsp.buf.range_formatting()' ]])

        -- TODO: This does not work too well, use autocmd for now
        -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        -- local opts = { noremap=true, silent=true }
        -- local opts = { }
        -- buf_set_keymap('v', 'gq', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
        -- buf_set_keymap('n', 'gq', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)

        -- Needed for spelling to work, otherwise it would spellcheck everything, like keywords etc
        vim.cmd([[ syntax on ]])
    end,
    sources = {
        null_ls.builtins.formatting.stylua.with({
            extra_args = { '--indent-type', 'Spaces', '--quote-style', 'AutoPreferSingle' },
            command = 'stylua',
        }),
        null_ls.builtins.formatting.clang_format.with({
            command = 'clang-format',
        }),
        null_ls.builtins.formatting.yapf.with({
            command = 'yapf',
        }),
        null_ls.builtins.formatting.rustfmt.with({
            extra_args = { '--edition', '2021' },
        }),
        -- null_ls.builtins.formatting.gofmt, -- done by goimports
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.golines.with({
            extra_args = { '--max-len', '120', '--shorten-comments' },
        }),
        null_ls.builtins.diagnostics.revive, -- for go linting, see ~/revive.toml
        null_ls.builtins.diagnostics.golangci_lint, -- for go linting
        null_ls.builtins.diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash' } }),

        -- This makes it so that formatexpr is set in ft=gitcommit and we can't run 'gq'
        -- null_ls.builtins.completion.spell,
    },
})

--- {{{ Colorscheme

require('kanagawa').setup({
    -- commentStyle = 'NONE',
    -- keywordStyle = 'NONE',
    -- variablebuiltinStyle = 'NONE',
    specialReturn = false,
    specialException = false,
    transparent = false,

    overrides = {
        NormalNC = { bg = '#181820' }, -- As suggested via rebelot/kanagawa.nvim/issues/17
    },
})

vim.api.nvim_create_user_command('GoLight', function(opts)
    vim.cmd('set background=light')
    vim.cmd("let $BAT_THEME='gruvbox-light'")
    require('kanagawa').setup({ overrides = { NormalNC = { bg = '#C8C093' } } })
    vim.cmd('colorscheme kanagawa')
    vim.cmd('highlight link GitSignsCurrentLineBlame TabLine')
end, {})
vim.api.nvim_create_user_command('GoDark', function(opts)
    vim.cmd('set background=dark')
    vim.cmd("let $BAT_THEME='gruvbox-dark'")
    require('kanagawa').setup({ overrides = { NormalNC = { bg = '#181820' } } })
    vim.cmd('colorscheme kanagawa')
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

day_callback = function()
    vim.cmd('GoLight')
end

night_callback = function()
    vim.cmd('GoDark')
end

require('sunset').setup({
    latitude = 57.7089,
    longitude = 11.9746,
    day_callback = day_callback,
    night_callback = night_callback,
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
})

vim.api.nvim_set_option('clipboard', 'unnamed')

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end
local luasnip = require('luasnip')
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
            -- vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    enabled = function()
        -- Disable completion in comments
        local context = require('cmp.config.context')
        -- Keep command mode completion enabled when cursor is in a comment
        -- if vim.api.nvim_get_mode().mode == 'c' then
        --     return true
        -- else
        --     return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
        -- end
        return true
    end,
    mapping = cmp.mapping.preset.insert({
        -- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- For snipets
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
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

require('colorizer').setup()

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
    -- Check https://todo.sr.ht/~whynothugo/lsp_lines.nvim/5
    virtual_text = false,

    float = {
        border = 'rounded',
        source = 'always', -- Which is good for null-ls, where we have multiple sources
    },
})
vim.keymap.set('', '<Leader>E', require('lsp_lines').toggle, { desc = 'Toggle lsp_lines' })
require('lsp_lines').setup()

require('diffview').setup({
    use_icons = false,
})

require('luasnip.loaders.from_vscode').lazy_load()

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

require('gitsigns').setup({
    numhl = true,
    current_line_blame = false,
    current_line_blame_opts = {
        virt_text_pos = 'right_align',
        delay = 200,
    },
    current_line_blame_formatter = ' <abbrev_sha>/<author>, <committer_time:%Y-%m-%d %X> - <summary>',
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                return ']c'
            end
            vim.schedule(function()
                gs.next_hunk({ navigation_message = true, wrap = false })
            end)
            return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
            if vim.wo.diff then
                return '[c'
            end
            vim.schedule(function()
                gs.prev_hunk({ navigation_message = true, wrap = false })
            end)
            return '<Ignore>'
        end, { expr = true })

        -- Actions
        map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function()
            gs.blame_line({ full = true })
        end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function()
            gs.diffthis('~')
        end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
})

require("no-neck-pain").setup({
    enableOnVimEnter = true,
    width = 160,
})

-- Default marker {{{ }}}
-- vim: foldmethod=marker foldlevel=0
