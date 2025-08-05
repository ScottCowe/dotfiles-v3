{ inputs, ... }:

let
  system = "x86_64-linux";
in
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };

  pkgs = import inputs.nixpkgs { inherit system; };
  lib = inputs.nixpkgs.lib;

  modules = [
    ./configuration.nix
  ];
}
