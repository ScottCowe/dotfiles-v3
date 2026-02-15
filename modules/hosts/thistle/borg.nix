{ ... }:

{
  flake.nixosModules.borg = {
    services.borgbackup.repos = {
      framework = {
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO60UvGLVPQgBla+H8WBj4B3n2lIrFTPRxqXIgE/4RF7 cowe@framework"
        ];
        path = "/var/lib/borg/framework";
        user = "borg";
      };
    };
  };
}
