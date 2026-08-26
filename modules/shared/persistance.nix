{ inputs, ... }: {
  flake.nixosModules.persistance =
    { lib, config, ... }:
    let
      cfg = config.persistance;
    in
    {
      key = "persistance";

      imports = [
        inputs.preservation.nixosModules.default
      ];

      options.persistance = {
        enable = lib.mkEnableOption "Enable preservation";

        # TODO: Types would be nice prolly
        dirs = lib.mkOption {
          default = [ ];
        };

        files = lib.mkOption {
          default = [ ];
        };

        user = lib.mkOption {
          default = null;
        };

        userDirs = lib.mkOption {
          default = [ ];
        };

        userFiles = lib.mkOption {
          default = [ ];
        };
      };

      config = lib.mkIf cfg.enable {
        preservation.enable = true;

        systemd.services.systemd-machine-id-commit = {
          unitConfig.ConditionPathIsMountPoint = [
            ""
            "/persist/etc/machine-id"
          ];
          serviceConfig.ExecStart = [
            ""
            "systemd-machine-id-setup --commit --root /persist"
          ];
        };

        preservation.preserveAt."/persist" = {
          directories = [
            {
              directory = "/var/lib/nixos";
              inInitrd = true;
            }
          ]
          ++ cfg.dirs;

          files = [
            {
              file = "/etc/machine-id";
              inInitrd = true;
              how = "symlink";
            }
          ]
          ++ cfg.files;

          users."${cfg.user}" = {
            directories = cfg.userDirs;
            files = cfg.userFiles;
          };
        };
      };
    };
}
