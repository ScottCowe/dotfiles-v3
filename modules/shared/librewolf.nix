{ self, ... }:
{
  flake.nixosModules.librewolf = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.librewolf ];

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [
      ".config/librewolf"
      ".cache/librewolf"
    ];
  };
}
