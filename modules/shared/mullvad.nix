{ self, ... }:

{
  flake.nixosModules.mullvad = { ... }: {
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.gui.enable = true;
    services.resolved.enable = true;

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [ ".config/'Mullvad VPN'" ];
  };
}
