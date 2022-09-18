-- For debugging, print anything
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "grr", -- As in 'very angry'!
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grN",
        },
    },
    refactor = {
        -- highlight_definitions = {
        --     enable = true
        -- },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "gd",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
            }
        },
    },
    textobjects = {
        enable = true,
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aC"] = "@class.outer",
                ["iC"] = "@class.inner",
                ["ac"] = "@conditional.outer",
                ["ic"] = "@conditional.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["is"] = "@statement.inner",
                ["as"] = "@statement.outer",
                ["am"] = "@call.outer",
                ["im"] = "@call.inner",
                ["ad"] = "@comment.outer",
                ["aa"] = "@parameter.inner", -- Works, but still not perfect, still leaves the separator (if any)
            },
        },
    },
}


local lspconfig = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    require('lsp_signature').on_attach({
        hint_enable = false,
        hi_parameter = 'IncSearch',
        toggle_key = '<M-q>',
    })

    -- Let null-ls handle the formatting
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    -- buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

lspconfig.ccls.setup {
    cmd = {
        'ccls', '--log-file=/tmp/' .. os.getenv('USER') .. '/cc.log'
    },
    init_options = {
        cache = {
            directory = '/tmp/' .. os.getenv('USER') .. '/ccls';
        },
        -- Set this via `pick_compile_command`
        compilationDatabaseDirectory = os.getenv("COMPILE_COMMANDS_DIR"),
        index = {
            initialBlacklist = {
                "./application",
                "./framework",
                "./toolbox",
                "./tools",
                "./up/dp/cdpi-main"
            };
            -- initialBlacklist = {"."};
        },
    },
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
}

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
                command = "clippy"
            },
            diagnostics = {
                disabled = { "unresolved-import" }
            },
            procMacro = {
                enable = true,
            },
        },
    },
})

util = require "lspconfig/util"

lspconfig.gopls.setup {
    cmd = {"gopls", "serve"},
    on_attach = on_attach,
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
}

lspconfig.salt_ls.setup {
    on_attach = on_attach,
}

lspconfig.jedi_language_server.setup {
    cmd = {
        'jedi-language-server',
    },
    on_attach = on_attach,
}

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

local null_ls = require("null-ls")
null_ls.setup({
    cmd = {os.getenv('HOME') .. '/neovim/build/bin/nvim'},
    on_attach = function()
        vim.cmd([[ command! -nargs=0 -range LspFormat execute 'lua vim.lsp.buf.range_formatting()' ]])

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
            command = os.getenv('HOME') .. '/.cargo/bin/stylua',
        }),
        null_ls.builtins.formatting.clang_format.with({
            command = 'clang-format',
        }),
        null_ls.builtins.formatting.yapf.with({
            command = os.getenv('HOME') .. '/.local/bin/yapf',
        }),
        null_ls.builtins.formatting.rustfmt.with({
            extra_args = { '--edition', '2021' },
        }),
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.revive, -- for go linting
        null_ls.builtins.diagnostics.staticcheck, -- for go linting
        null_ls.builtins.diagnostics.shellcheck.with({ filetypes = { 'sh', 'bash' } }),
    },
})

require('kanagawa').setup({
    -- commentStyle = 'NONE',
    -- keywordStyle = 'NONE',
    -- variablebuiltinStyle = 'NONE',
    specialReturn = false,
    specialException = false,
    transparent = false,

    -- This needs to be readjusted for bg=light
    overrides = {
        NormalFloat = { bg = '#223249' }, -- waveBlue1
        Visual = { bg = '#2D4F67' }, -- waveBlue2
        Search = { bg = '#938AA9' }, -- springViolet1
        NormalNC = { bg = '#181820' }, -- As suggested via rebelot/kanagawa.nvim/issues/17
    },
})

vim.cmd("colorscheme kanagawa")

require'lualine'.setup()

require('smoothcursor').setup({
    cursor = '',
    fancy = {
        enable = true,
        head = { cursor = "", texthl = "SmoothCursor", linehl = nil },
    },
})
