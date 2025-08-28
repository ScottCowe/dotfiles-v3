{ inputs, ... }:

let
  system = "x86_64-linux";
in
inputs.nixpkgs-unstable.lib.nixosSystem {
  specialArgs = { inherit inputs; };

  pkgs = import inputs.nixpkgs-unstable { inherit system; };
  lib = inputs.nixpkgs-unstable.lib;

  modules = [
    ./hardware-config.nix
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./configuration.nix
  ];
}
