{
  flake.nixosModules.mako = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.mako ];
  };
}
