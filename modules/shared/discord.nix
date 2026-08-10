{
  flake.nixosModules.discord = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.discord ];
    persistance.userDirs = [ ".config/discord" ];
  };
}
