{ self, ... }: {
  flake.nixosModules.mako = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.mako ];
  };

  perSystem = { pkgs, ... }: {
    packages.mako =
      let
        configFile = pkgs.writeText "mako-config" ''
          default-timeout=5000
        '';
      in
      (pkgs.symlinkJoin {
        name = "mako";
        paths = [ pkgs.mako ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/mako \
            --add-flags '--config' \
            --add-flags '${configFile}'
        '';
      });
  };
}
