{ self, ... }:

{
  flake.nixosModules.signal = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.signal-desktop ];

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [ ".config/Signal" ];
  };
}
