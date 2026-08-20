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
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

vim.cmd("colorscheme kanagawa")

vim.lsp.enable({ 'lua_ls', 'nixd', 'rust_analyzer', 'ts_ls', 'svelte' })

vim.keymap.set("n", "<Leader>e", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<Leader>t", "<cmd>tabnew<CR>")
vim.keymap.set("n", "th", "<cmd>tabprevious<CR>")
vim.keymap.set("n", "tl", "<cmd>tabnext<CR>")
vim.keymap.set("n", "<leader>h", "<cmd>split<CR>")
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<CR>")
vim.keymap.set({ 'n', 't' }, '<C-h>', '<C-w>h')
vim.keymap.set({ 'n', 't' }, '<C-j>', '<C-w>j')
vim.keymap.set({ 'n', 't' }, '<C-k>', '<C-w>k')
vim.keymap.set({ 'n', 't' }, '<C-l>', '<C-w>l')
vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float)

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

require('nvim-tree').setup()
require('nvim-web-devicons').setup({
    -- your personal icons can go here (to override)
    -- you can specify color or cterm_color instead of specifying both of them
    -- DevIcon will be appended to `name`
    override = {
        zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
        }
    },
    -- globally enable different highlight colors per icon (default to true)
    -- if set to false all icons will have the default icon's color
    color_icons = true,
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true,
    -- globally enable "strict" selection of icons - icon will be looked up in
    -- different tables, first by filename, and if not found by extension; this
    -- prevents cases when file doesn't have any extension but still gets some icon
    -- because its name happened to match some extension (default to false)
    strict = true,
    -- set the light or dark variant manually, instead of relying on `background`
    -- (default to nil)
    variant = "light|dark",
    -- override blend value for all highlight groups :h highlight-blend.
    -- setting this value to `0` will make all icons opaque. in practice this means
    -- that icons width will not be affected by pumblend option (see issue #608)
    -- (default to nil)
    blend = 0,
    -- same as `override` but specifically for overrides by filename
    -- takes effect when `strict` is true
    override_by_filename = {
        [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore"
        }
    },
    -- same as `override` but specifically for overrides by extension
    -- takes effect when `strict` is true
    override_by_extension = {
        ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log"
        }
    },
    -- same as `override` but specifically for operating system
    -- takes effect when `strict` is true
    override_by_operating_system = {
        ["apple"] = {
            icon = "",
            color = "#A2AAAD",
            cterm_color = "248",
            name = "Apple",
        },
    },
})
