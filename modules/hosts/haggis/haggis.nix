{ inputs, self, ... }:

{
  flake.nixosConfigurations.haggis = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.haggis-config

      # self.nixosModules.neovim
      self.nixosModules.niri
    ];
  };

  flake.nixosModules.haggis-config =
    { modulesPath, pkgs, ... }:
    {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
      ];

      environment.systemPackages = with pkgs; [
        disko
      ];

      isoImage.squashfsCompression = "gzip -Xcompression-level 1";
    };
}
