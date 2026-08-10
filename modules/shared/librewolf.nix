{
  flake.nixosModules.librewolf = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.librewolf ];
    persistance.userDirs = [
      ".config/librewolf"
      ".cache/librewolf"
    ];
  };
}
