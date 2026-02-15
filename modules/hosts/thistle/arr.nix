{ ... }:

{
  flake.nixosModules.sonarr = {
    services.sonarr = {
      enable = true;
      openFirewall = true;
    };
  };

  flake.nixosModules.radarr = {
    services.radarr = {
      enable = true;
      openFirewall = true;
    };
  };

  flake.nixosModules.lidarr = {
    services.lidarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
