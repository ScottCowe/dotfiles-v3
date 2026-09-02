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
vim.keymap.set("n", "<C-t>", "<cmd>tabnew<CR>")

-- surely theres a nicer way to do this?
vim.keymap.set("n", "<Leader>1", "<cmd>tabn 1<CR>")
vim.keymap.set("n", "<Leader>2", "<cmd>tabn 2<CR>")
vim.keymap.set("n", "<Leader>3", "<cmd>tabn 3<CR>")
vim.keymap.set("n", "<Leader>4", "<cmd>tabn 4<CR>")
vim.keymap.set("n", "<Leader>5", "<cmd>tabn 5<CR>")
vim.keymap.set("n", "<Leader>6", "<cmd>tabn 6<CR>")
vim.keymap.set("n", "<Leader>7", "<cmd>tabn 7<CR>")
vim.keymap.set("n", "<Leader>8", "<cmd>tabn 8<CR>")
vim.keymap.set("n", "<Leader>9", "<cmd>tabn 9<CR>")
vim.keymap.set("n", "<Leader>10", "<cmd>tabn 10<CR>")

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

require('nvim-tree').setup({
    on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.map.on_attach.default(bufnr)

        vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
        vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
        vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
        vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
        vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set({ "n", "x" }, "<Del>", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
        vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
        vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
        vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
        vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "a", api.fs.create, opts("Create File Or Directory"))
        vim.keymap.set("n", "bd", api.marks.bulk.delete, opts("Delete Bookmarked"))
        vim.keymap.set("n", "bt", api.marks.bulk.trash, opts("Trash Bookmarked"))
        vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
        vim.keymap.set("n", "B", api.filter.no_buffer.toggle, opts("Toggle Filter: No Buffer"))
        vim.keymap.set({ "n", "x" }, "c", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "C", api.filter.git.clean.toggle, opts("Toggle Filter: Git Clean"))
        vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
        vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
        vim.keymap.set({ "n", "x" }, "d", api.fs.remove, opts("Delete"))
        vim.keymap.set({ "n", "x" }, "D", api.fs.trash, opts("Trash"))
        vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
        vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
        vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
        vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
        vim.keymap.set("n", "F", api.filter.live.clear, opts("Live Filter: Clear"))
        vim.keymap.set("n", "f", api.filter.live.start, opts("Live Filter: Start"))
        vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
        vim.keymap.set({ "n", "x" }, "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
        vim.keymap.set("n", "ge", api.fs.copy.basename, opts("Copy Basename"))
        vim.keymap.set("n", "H", api.filter.dotfiles.toggle, opts("Toggle Filter: Dotfiles"))
        vim.keymap.set("n", "I", api.filter.git.ignored.toggle, opts("Toggle Filter: Git Ignored"))
        vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
        vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
        vim.keymap.set("n", "L", api.node.open.toggle_group_empty, opts("Toggle Group Empty"))
        vim.keymap.set("n", "M", api.filter.no_bookmark.toggle, opts("Toggle Filter: No Bookmark"))
        vim.keymap.set({ "n", "x" }, "m", api.marks.toggle, opts("Toggle Bookmark"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "gp", api.fs.move, opts("Move"))
        vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
        vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
        vim.keymap.set("n", "u", api.fs.rename_full, opts("Rename: Full Path"))
        vim.keymap.set("n", "U", api.filter.custom.toggle, opts("Toggle Filter: Custom"))
        vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse All"))
        vim.keymap.set({ "n", "x" }, "x", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
        vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
    end
})

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
