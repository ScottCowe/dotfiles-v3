{ self, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.neovim = (
        inputs.wrappers.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.neovim;
          runtimeInputs = [
            pkgs.lua-language-server
            pkgs.nixd
            pkgs.nixfmt
          ];
          env.XDG_CONFIG_HOME = toString (
            pkgs.linkFarm "nvim-linkfarm" (
              [
                {
                  name = "nvim/init.lua";
                  path = ./init.lua;
                }
                {
                  name = "nvim/lua/plugins/lualine.lua";
                  path = ./lua/plugins/lualine.lua;
                }
                {
                  name = "nvim/pack/vendor/start/lualine.nvim";
                  path = pkgs.vimPlugins.lualine-nvim;
                }
              ]
              ++ (map
                (x: {
                  name = "nvim/lsp/${x}";
                  path = ./lsp/${x};
                })
                (
                  lib.mapAttrsToList (n: v: n) (
                    lib.filterAttrs (na: va: va == "regular" && lib.hasSuffix ".lua" na) (builtins.readDir ./lsp)
                  )
                )
              )
            )
          );
        }
      );
    };
}
