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
                    expr = '(builtins.getFlake (toString ./.)).nixosConfigurations.<hostname>.options',
                },
            },
        },
    },
}
