{ ... }: {
  flake.nixosModules.chromium = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.chromium ];

    # Not persisting data as chromium is not main browser
    # TODO: Adblock extensions and browser policies
  };
}
