return {
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
}
