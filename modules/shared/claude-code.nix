{
  flake.nixosModules.claude-code = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.claude-code ];

    persistance.userDirs = [ ".claude" ];
    persistance.userFiles = [ ".claude.json" ];
  };
}
