{
  description = "Version 3 of ScottCowe's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, ... }@inputs:
    {
      nixosConfigurations = {
        unicorn =
          let
            system = "x86_64-linux";
          in
          inputs.nixpkgs-unstable.lib.nixosSystem {
            specialArgs = { inherit inputs; };

            pkgs = import inputs.nixos-unstable { inherit system; };
            lib = inputs.nixpkgs-unstable.lib;

            modules = [

            ];
          };
      };
    };
}
