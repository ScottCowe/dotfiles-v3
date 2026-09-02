{ inputs, self, ... }: {
  flake.nixosModules.sonora = { pkgs, ... }: {
    environment.systemPackages = [ inputs.sonora.packages.${pkgs.stdenv.hostPlatform.system}.default ];

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [
      ".config/sonora"
      ".cache/sonora"
      ".local/share/sonora"
      ".local/state/sonora"
    ];
  };
}
