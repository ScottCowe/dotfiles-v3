{ self, ... }:

{
  flake.nixosModules.gnucash = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gnucash ];

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [
      ".config/gnucash"
      ".local/share/gnucash"
    ];
  };
}
