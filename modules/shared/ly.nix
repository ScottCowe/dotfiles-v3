{
  flake.nixosModules.ly = { pkgs, ... }: {
    services.displayManager.ly =
      let
        lyCommunityDur =
          dur:
          pkgs.stdenv.mkDerivation {
            name = "${dur}";

            src = pkgs.fetchFromGitea {
              domain = "codeberg.org";
              owner = "fairyglade";
              repo = "ly-community";
              rev = "2f22cfaf7d17598c8f60f562d56e16d74b6c99ab";
              hash = "sha256-BQhlvWmEkXNpbUgtGBzbHjdQwRa2jxHhBBNu8sVzIDQ=";
            };

            installPhase = ''
              mkdir -p $out
              cp $src/animations/dur/${dur} $out/
            '';
          };
      in
      {
        enable = true;
        settings = {
          animation = "matrix"; # "dur_file";
          # dur_file_path = "${lyCommunityDur "blackhole-smooth-240x67.dur"}/blackhole-smooth-240x67.dur";
        };
      };
  };
}
