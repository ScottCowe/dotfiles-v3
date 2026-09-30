{ self, ... }:

{
  flake.nixosModules.factorio = { pkgs, config, ... }: {
    sops.secrets."factorio/env" = { };

    systemd.services."nix-daemon".serviceConfig.EnvironmentFile =
      config.sops.secrets."factorio/env".path;
    systemd.services."nix-daemon@".serviceConfig.EnvironmentFile =
      config.sops.secrets."factorio/env".path;

    environment.systemPackages = [
      (pkgs.factorio.override {
        releaseType = "expansion";
      })
    ];

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [ ".factorio" ];
  };
}
