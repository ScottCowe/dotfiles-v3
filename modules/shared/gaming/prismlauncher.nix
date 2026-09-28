{ self, ... }: {
  flake.nixosModules.prismlauncher = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.prismlauncher ];

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [ ".local/share/PrismLauncher" ];
  };
}
