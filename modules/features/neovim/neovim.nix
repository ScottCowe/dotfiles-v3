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

          env.XDG_DATA_DIRS = toString (
            pkgs.linkFarm "nvim-plugins" [
              {
                name = "nvim/site/pack/plugins/start/kanagawa-nvim";
                path = pkgs.vimPlugins.kanagawa-nvim;
              }
              {
                name = "nvim/site/pack/plugins/start/lualine.nvim";
                path = pkgs.vimPlugins.lualine-nvim;
              }
              {
                name = "nvim/site/pack/plugins/start/blink-cmp";
                path = pkgs.vimPlugins.blink-cmp;
              }
              {
                name = "nvim/site/pack/plugins/start/nvim-treesitter";
                path = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
              }
              {
                name = "nvim/site/pack/plugins/start/nvim-treesitter-parsers-lua";
                path = pkgs.vimPlugins.nvim-treesitter-parsers.lua;
              }
              {
                name = "nvim/site/pack/plugins/start/nvim-treesitter-parsers-nix";
                path = pkgs.vimPlugins.nvim-treesitter-parsers.nix;
              }
            ]
          );

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
                  name = "nvim/lua/plugins/blink.lua";
                  path = ./lua/plugins/blink.lua;
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
