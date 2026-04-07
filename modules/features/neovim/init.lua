require("plugins.lualine")

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

vim.g.mapleader = ' '

vim.lsp.enable({'lua', 'nix'})

vim.keymap.set("n", "<Leader>e", "<cmd>Ex %:p:h<CR>")
vim.keymap.set("n", "<Leader>t", "<cmd>tabnew<CR>")
vim.keymap.set("n", "th", "<cmd>tabprevious<CR>")
vim.keymap.set("n", "tl", "<cmd>tabnext<CR>")
vim.keymap.set("n", "<leader>h", "<cmd>split<CR>")
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<CR>")
vim.keymap.set({'n', 't'}, '<C-h>', '<C-w>h')
vim.keymap.set({'n', 't'}, '<C-j>', '<C-w>j')
vim.keymap.set({'n', 't'}, '<C-k>', '<C-w>k')
vim.keymap.set({'n', 't'}, '<C-l>', '<C-w>l')
