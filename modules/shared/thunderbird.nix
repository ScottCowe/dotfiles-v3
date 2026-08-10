{
  flake.nixosModules.thunderbird = {
    programs.thunderbird.enable = true;
    persistance.userDirs = [ ".thunderbird" ];
  };
}
