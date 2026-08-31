{ self, ... }: {
  flake.nixosModules.vintagestory = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vintagestory ];

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [ ".config/VintagestoryData/" ];
  };
}
