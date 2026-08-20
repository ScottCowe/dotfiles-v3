{ self, ... }: {
  # Can't just do this like a normal person because of some fuckery when trying to override a symlinkJoin'd package
  # Will fix later (when it becomes a problem)
  # Config options are taken from nixpkgs
  flake.nixosModules.hyprland =
    { pkgs, lib, ... }:
    let
      hyprlandPackage = self.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    in
    {
      environment = {
        systemPackages = [
          hyprlandPackage
          pkgs.grim
          pkgs.slurp
        ];

        # Allows lua stub file to be accessed from /run/current-system/sw/share/hypr
        pathsToLink = [ "/share/hypr" ];
      };

      # Hyprland needs permissions to give itself SCHED_RR on startup:
      # https://github.com/hyprwm/Hyprland/blob/main/src/init/initHelpers.cpp
      security.wrappers.Hyprland = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_nice+ep";
        source = lib.getExe hyprlandPackage;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [ portalPackage ];
        configPackages = lib.mkDefault [ hyprlandPackage ];
      };

      # To make the Hyprland session available in DM
      services.displayManager.sessionPackages = [ hyprlandPackage ];

      security = {
        polkit.enable = true;
        pam.services.swaylock = { };
      };

      programs = {
        dconf.enable = true;
        xwayland.enable = true;
      };

      services.graphical-desktop.enable = true;

      # Window manager only sessions (unlike DEs) don't handle XDG
      # autostart files, so force them to run the service
      services.xserver.desktopManager.runXdgAutostartIfNone = true;
    };

  perSystem = { pkgs, lib, ... }: {
    packages.hyprland =
      let
        terminal = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.kitty}";
        launcher = "${lib.getExe pkgs.fuzzel}";

        runOnStartup = [
          "blueman-applet"
          "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.bar} open bar"
          "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.mako}"
          "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper}"
        ];

        startupConfig = ''
          hl.on("hyprland.start", function()
          ${lib.concatStrings (map (x: "\thl.exec_cmd(\"${x}\")\n") runOnStartup)}
          end)
        '';

        # TODO: Try make screenshot work with string interpolation
        configDir = pkgs.runCommand "hyprland-config-dir" { } ''
          mkdir -p $out

          cp ${./hyprland.lua} $out/hyprland.lua

          cp ${./binds.lua} $out/binds.lua
          substituteInPlace $out/binds.lua \
            --replace-fail "terminal" "${terminal}" \
            --replace-fail "launcher" "${launcher}" \
            --replace-fail "screenshot" "${lib.getExe pkgs.grim} -g \"\$(${lib.getExe pkgs.slurp})\" - | ${pkgs.wl-clipboard}/bin/wl-copy --type image/png" \

          cp ${./monitors.lua} $out/monitors.lua

          touch $out/startup.lua 
          echo '${startupConfig}' > $out/startup.lua
        '';
      in
      pkgs.symlinkJoin {
        name = "Hyprland";

        paths = [
          (pkgs.hyprland.override {
            withSystemd = false;
          })
        ];

        nativeBuildInputs = [ pkgs.makeWrapper ];

        postBuild = ''
          wrapProgram $out/bin/Hyprland \
            --add-flags '--config' \
            --add-flags '${configDir}/hyprland.lua' \
        '';

        passthru.providedSessions = [ "hyprland" ];
        meta.mainProgram = "Hyprland";
      };
  };
}
