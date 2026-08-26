{ self, ... }: {
  flake.nixosModules.discord = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.discord ];

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [ ".config/discord" ];
  };
}
