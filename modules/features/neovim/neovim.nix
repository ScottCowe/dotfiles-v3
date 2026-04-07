{ self, inputs, ... }:
{
  perSystem =
    { pkgs, self', ... }:
    {
      packages.neovim = (
        inputs.wrappers.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.neovim;
          env.XDG_CONFIG_HOME = toString (
            pkgs.linkFarm "nvim-linkfarm" [
              {
                name = "nvim/init.lua";
                path = ./init.lua;
              }
            ]
          );
        }
      );
    };
}
