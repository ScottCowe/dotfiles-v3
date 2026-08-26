{ self, ... }:
{
  flake.nixosModules.thunderbird = {
    programs.thunderbird.enable = true;

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [ ".thunderbird" ];
  };
}
