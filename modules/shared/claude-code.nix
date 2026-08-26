{ self, ... }: {
  flake.nixosModules.claude-code = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.claude-code ];

    imports = [ self.nixosModules.persistance ];
    persistance.userDirs = [ ".claude" ];
    persistance.userFiles = [ ".claude.json" ];
  };
}
