vim.o.number = true
vim.o.relativenumber = true;
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.cursorline = true
vim.o.termguicolors = false
vim.o.showtabline = 1
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = ' '

vim.cmd("colorscheme kanagawa")

vim.lsp.enable({ 'lua', 'nix', 'rust', 'ts', 'svelte' })

vim.lsp.config('lua', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        ".luarc.json", ".luarc.jsonc", ".luacheckrc",
        ".stylua.toml", "stylua.toml", "selene.toml",
        "selene.yml", ".git"
    },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            completion = { enable = true, },
            diagnostics = { enable = true, globals = { "vim" } },
            workspace = {
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
            },
        },
    },
})

vim.lsp.config('nix', {
    cmd = { 'nixd' },
    filetypes = { 'nix' },
    root_markers = { 'flake.nix', '.git' }, --TODO: More root markers
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> { }",
            },
            formatting = {
                command = { "nixfmt" },
            },
            options = {
                nixos = {
                    expr = '(builtins.getFlake (toString ./.)).nixosConfigurations.<hostname>.options',
                },
            },
        },
    },
})

vim.lsp.config('rust', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = {
        "Cargo.toml", ".git"
    },
    settings = {
        imports = {
            granularity = {
                group = "module",
            },
            prefix = "self",
        },
        cargo = {
            buildScripts = { enable = true },
            autoreload = false
        },
        procMacro = {
            enable = true
        }
    }
})

vim.lsp.config('svelte', {
    cmd = { 'svelte-language-server', '--stdio' },
    filetypes = {
        'svelte'
    },
    root_markers = {
        "package.json", ".git"
    },
    settings = {

    },
})

vim.lsp.config('ts', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {
        'typescript', 'typescriptreact',
        'javascript', 'javascriptreact',
    },
    root_markers = {
        "package.json", ".git"
    },
    settings = {

    },
})

vim.keymap.set("n", "<Leader>e", "<cmd>Ex %:p:h<CR>")
vim.keymap.set("n", "<Leader>t", "<cmd>tabnew<CR>")
vim.keymap.set("n", "th", "<cmd>tabprevious<CR>")
vim.keymap.set("n", "tl", "<cmd>tabnext<CR>")
vim.keymap.set("n", "<leader>h", "<cmd>split<CR>")
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<CR>")
vim.keymap.set({ 'n', 't' }, '<C-h>', '<C-w>h')
vim.keymap.set({ 'n', 't' }, '<C-j>', '<C-w>j')
vim.keymap.set({ 'n', 't' }, '<C-k>', '<C-w>k')
vim.keymap.set({ 'n', 't' }, '<C-l>', '<C-w>l')

vim.treesitter.language.register('nix', { 'nix' });
vim.treesitter.language.register('tsx', { 'typescriptreact' });

vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
vim.cmd("colorscheme kanagawa")

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true }),
    pattern = { "nix" },
    command = "setlocal shiftwidth=2 tabstop=2",
})

require('nvim-autopairs').setup()
require('ibl').setup()
require('lean').setup({
    mappings = true,
    graphics = {
        enabled = true
    }
})
require('nvim-ts-autotag').setup({
    opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false
    },
})

require("lualine").setup({})

require('blink.cmp').setup({
    keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<C-a>'] = { 'select_and_accept', 'fallback' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
        nerd_font_variant = 'mono'
    },

    completion = { documentation = { auto_show = false } },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" }
})
