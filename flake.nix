{
  description = "Version 3 of ScottCowe's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs.url = "github:serokell/deploy-rs";

    cowedev.url = "github:ScottCowe/cowe.dev";
  };

  outputs =
    { self, ... }@inputs:
    {
      # nixosConfigurations.unicorn = import ./hosts/unicorn { inherit inputs; };

      nixosConfigurations.selkie = import ./hosts/selkie { inherit inputs; };

      nixosConfigurations.heather = import ./hosts/heather { inherit inputs; };
      deploy.nodes.heather = import ./hosts/heather/deploy.nix { inherit inputs self; };

      checks = builtins.mapAttrs (
        system: deployLib: deployLib.deployChecks self.deploy
      ) inputs.deploy-rs.lib;
    };
}
