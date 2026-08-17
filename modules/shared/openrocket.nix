{
  flake.nixosModules.openrocket = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.openrocket ];
  };
}
