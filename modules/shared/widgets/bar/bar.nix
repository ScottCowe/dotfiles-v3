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
          {
            name = "scripts/battery.py";
            path = ../scripts/battery.py;
          }
        ];

        # Anything but installing python systemwide
        things = [
          pkgs.python3
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
                --prefix PATH : ${lib.makeBinPath things}
        '';
        meta.mainProgram = "eww";
      };
  };
}
