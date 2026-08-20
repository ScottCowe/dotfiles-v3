{ self, ... }: {
  flake.nixosModules.kitty = { pkgs, ... }: {
    programs.kitty = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.kitty;
    };
  };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.kitty =
        let
          config = pkgs.writeText "kitty-config" ''
            font_family family="Fira Code"
          '';
        in
        pkgs.symlinkJoin {
          name = "kitty";
          paths = [ pkgs.kitty ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/kitty \
              --add-flags "--config" \
              --add-flags "${config}" \
          '';
        };
    };
}
