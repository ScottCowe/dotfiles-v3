{ self, inputs, ... }:
{
  flake.checks = builtins.mapAttrs (
    system: deployLib: deployLib.deployChecks self.deploy
  ) inputs.deploy-rs.lib;

  flake.deploy.nodes.selkie = {
    hostname = "100.118.34.125";
    sshUser = "admin";
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.selkie;
    };
  };

  flake.deploy.nodes.thistle = {
    hostname = "100.118.34.125";
    sshUser = "admin";
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.thistle;
    };
  };

  flake.deploy.nodes.heather = {
    hostname = "65.108.219.172";
    sshUser = "admin";
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.heather;
    };
  };
}
