{
  perSystem = { pkgs, lib, ... }: {
    packages.hyprpaper =
      let
        wallpaper = ./jupiter-wallpaper.png;

        config = pkgs.writeText "hyprpaper-config" ''
          wallpaper {
              monitor = 
              path = ${wallpaper}
              fit_mode = cover
          }
        '';
      in
      pkgs.symlinkJoin {
        name = "hyprpaper";

        paths = [
          pkgs.hyprpaper
        ];

        nativeBuildInputs = [ pkgs.makeWrapper ];

        postBuild = ''
          wrapProgram $out/bin/hyprpaper \
            --add-flags '--config' \
            --add-flags '${config}' \
        '';

        meta.mainProgram = "hyprpaper";
      };
  };
}
