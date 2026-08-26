{ self, ... }:
{
  flake.nixosModules.steam = {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [
      ".local/share/Steam"
      ".steam"

      ".factorio"
    ];
  };
}
