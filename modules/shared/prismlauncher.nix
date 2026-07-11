{
  flake.nixosModules.prismlauncher = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.prismlauncher ];
  };
}
