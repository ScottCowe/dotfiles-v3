{ ... }:

{
  flake.nixosModules.not-piracy = {
    services.qbittorrent = {
      enable = true;
      openFirewall = true;

      webuiPort = 8081;

      serverConfig = {
        LegalNotice.Accepted = true;
        Preferences = {
          WebUI = {
            Username = "admin";
            Password_PBKDF2 = "@ByteArray(j5TcOQWNPJXF9uL2rcbbiA==:v41IHOXJe1QgpDwAzf2BSMO6zy4Nk2vkB6+p5tgPHpioozw/uraIcxrXTJOz28Ovec4MuIseoFzLmvzpMFAbkQ==)";
          };
          General.Locale = "en";
        };
      };
    };
  };

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
