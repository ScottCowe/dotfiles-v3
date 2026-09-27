{ self, ... }:

{
  flake.nixosModules.docker = { ... }: {
    virtualisation.docker.enable = true;
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [ ".local/share/docker" ];
  };
}
