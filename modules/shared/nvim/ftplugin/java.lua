local config = {
    name = "jdtls",
    cmd = { "jdtls" },
    root_dir = vim.fs.root(0, { 'gradlew', '.git', 'mvnw' }),
    settings = {
        java = {
        }
    },
    init_options = {
        bundles = {}
    },
    on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

        vim.keymap.set('n', '<leader>o', require('jdtls').organize_imports, opts)

        -- TODO: Extract variable, constant, method keymaps
    end
}

require('jdtls').start_or_attach(config)
