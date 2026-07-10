{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.myNiri =
        (inputs.wrappers.wrapperModules.niri.apply {
          inherit pkgs;
          settings = {
            spawn-at-startup = [ "blueman-applet" ];
            binds = {
              "Mod+Return" = {
                spawn-sh = lib.getExe pkgs.kitty;
                _attrs = {
                  repeat = false;
                };
              };
              "Mod+Q".close-window = null;
              "Mod+H".focus-column-left = null;
              "Mod+J".focus-window-down = null;
              "Mod+K".focus-window-up = null;
              "Mod+L".focus-column-right = null;
              "Mod+B" = {
                spawn-sh = lib.getExe pkgs.librewolf;
                _attrs = {
                  repeat = false;
                };
              };
              "Mod+Shift+Q".quit = null;
              "Mod+D" = {
                spawn-sh = lib.getExe pkgs.fuzzel;
                _attrs = {
                  repeat = false;
                };
              };
            };
          };
        }).wrapper;
    };
}
