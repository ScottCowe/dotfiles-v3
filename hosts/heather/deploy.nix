{ inputs, self, ... }:

{
  hostname = "65.108.219.172";
  sshUser = "admin";
  profiles.system = {
    user = "root";
    path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.heather;
  };
}
