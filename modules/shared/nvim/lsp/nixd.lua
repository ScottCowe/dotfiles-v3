return {
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
                    -- TODO: Some solution to fix this so that I can use it outside editing this specific config
                    expr = '(builtins.getFlake (toString ./.)).nixosConfigurations.unicorn.options',
                },
            },
        },
    },
}
