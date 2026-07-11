{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      };

      environment.systemPackages = [ pkgs.xwayland-satellite ];
    };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.niri =
        (inputs.wrappers.wrapperModules.niri.apply {
          inherit pkgs;
          settings = {
            spawn-at-startup = [ "blueman-applet" ];

            outputs = {
              "eDP-1" = {
                position = {
                  _attrs = {
                    x = 1920;
                    y = 0;
                  };
                };
              };
              "DP-3" = {
                position = {
                  _attrs = {
                    x = 0;
                    y = 0;
                  };
                };
              };
            };

            binds = {
              "Mod+Q".close-window = null;
              "Mod+Shift+Q".quit = null;

              "Mod+Return" = {
                spawn-sh = lib.getExe pkgs.kitty;
                _attrs = {
                  repeat = false;
                };
              };
              "Mod+D" = {
                spawn-sh = lib.getExe pkgs.fuzzel;
                _attrs = {
                  repeat = false;
                };
              };
              "Mod+B" = {
                spawn-sh = lib.getExe pkgs.librewolf;
                _attrs = {
                  repeat = false;
                };
              };

              "Mod+H".focus-column-left = null;
              "Mod+J".focus-window-down = null;
              "Mod+K".focus-window-up = null;
              "Mod+L".focus-column-right = null;
              "Mod+Shift+H".move-column-left = null;
              "Mod+Shift+J".move-window-down = null;
              "Mod+Shift+K".move-window-up = null;
              "Mod+Shift+L".move-column-right = null;
              "Mod+Left".focus-monitor-left = null;
              "Mod+Down".focus-monitor-down = null;
              "Mod+Up".focus-monitor-up = null;
              "Mod+Right".focus-monitor-right = null;
              "Mod+Shift+Left".move-column-to-monitor-left = null;
              "Mod+Shift+Down".move-column-to-monitor-down = null;
              "Mod+Shift+Up".move-column-to-monitor-up = null;
              "Mod+Shift+Right".move-column-to-monitor-right = null;

              "Mod+F".maximize-column = null;
              "Mod+Shift+F".fullscreen-window = null;
            };
          };
        }).wrapper;
    };
}
