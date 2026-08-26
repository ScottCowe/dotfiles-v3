{ self, ... }:
{
  flake.nixosModules.devenv = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.devenv ];
    programs.direnv.enable = true;

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [ ".local/share/direnv" ];
  };
}
