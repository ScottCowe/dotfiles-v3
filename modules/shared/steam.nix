{
  flake.nixosModules.steam = {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    persistance.userDirs = [
      ".local/share/Steam"
      ".steam"

      ".factorio"
    ];
  };
}
