{
  flake.nixosModules.librewolf = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.librewolf ];
  };
}
