{ self, inputs, ... }: {
  flake.nixosModules.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.git;
    };
  };

  perSystem = { pkgs, ... }: {
    packages.git =
      (inputs.wrappers.wrapperModules.git.apply {
        inherit pkgs;
        settings = {
          user = {
            name = "Scott Cowe";
            email = "scott.t.cowe@gmail.com";
          };
          core.editor = "vim";
        };
      }).wrapper;
  };
}
