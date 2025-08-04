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
  };

  outputs =
    { self, ... }@inputs:
    {
      nixosConfigurations = {
        # unicorn =
        #   let
        #     system = "x86_64-linux";
        #   in
        #   inputs.nixpkgs-unstable.lib.nixosSystem {
        #     specialArgs = { inherit inputs; };
        #
        #     pkgs = import inputs.nixpkgs-unstable { inherit system; };
        #     lib = inputs.nixpkgs-unstable.lib;
        #
        #     modules = [
        #
        #     ];
        #   };

        heather =
          let
            system = "x86_64-linux";
          in
          inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };

            pkgs = import inputs.nixpkgs { inherit system; };
            lib = inputs.nixpkgs.lib;

            modules = [
              ./hosts/heather/configuration.nix
            ];
          };
      };

      deploy.nodes.heather = import ./hosts/heather/deploy.nix { inherit inputs self; };

      checks = builtins.mapAttrs (
        system: deployLib: deployLib.deployChecks self.deploy
      ) inputs.deploy-rs.lib;
    };
}
