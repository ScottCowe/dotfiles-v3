{
  flake.nixosModules.prismlauncher = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.prismlauncher ];
    persistance.userDirs = [ ".local/share/PrismLauncher" ];
  };
}
