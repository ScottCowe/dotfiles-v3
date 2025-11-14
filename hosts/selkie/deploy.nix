{ inputs, self, ... }:

{
  hostname = "100.118.34.125";
  sshUser = "admin";
  profiles.system = {
    user = "root";
    path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.selkie;
  };
}
