{ inputs, self, ... }:

{
  flake.nixosConfigurations.haggis = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.haggis-config

      # self.nixosModules.neovim
      self.nixosModules.niri
      self.nixosModules.git
      self.nixosModules.keyd
    ];
  };

  flake.nixosModules.haggis-config =
    {
      modulesPath,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
      ];

      environment.systemPackages = with pkgs; [
        disko
      ];

      networking = {
        hostName = "haggis";
        networkmanager.enable = true;
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      isoImage.volumeID = lib.mkForce "haggis";
      isoImage.isoName = lib.mkForce "haggis.iso";
      isoImage.squashfsCompression = "gzip -Xcompression-level 1";

      i18n.defaultLocale = "en_US.UTF-8";
      time.timeZone = "London/Europe";

      system.stateVersion = "26.05";
    };
}
