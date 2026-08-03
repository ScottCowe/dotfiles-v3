{
  perSystem = { pkgs, lib, ... }: {
    packages.bar =
      let
        configDir = pkgs.linkFarm "bar-config-dir" [
          {
            name = "eww.yuck";
            path = ./config.yuck;
          }
          {
            name = "eww.scss";
            path = ./style.scss;
          }
        ];
      in
      pkgs.symlinkJoin {
        name = "eww";
        paths = [
          pkgs.eww
        ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/eww \
                --add-flags '-c' \
                --add-flags '${configDir}' \
                --add-flags 'open' \
                --add-flags 'bar'
        '';
      };
  };
}
