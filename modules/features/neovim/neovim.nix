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
            pkgs.linkFarm "nvim-plugins" (
              [
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
                  name = "nvim/site/pack/plugins/start/gitsigns.nvim";
                  path = pkgs.vimPlugins.gitsigns-nvim;
                }
                {
                  name = "nvim/site/pack/plugins/start/nvim-autopairs";
                  path = pkgs.vimPlugins.nvim-autopairs;
                }
                {
                  name = "nvim/site/pack/plugins/start/indent-blankline-nvim";
                  path = pkgs.vimPlugins.indent-blankline-nvim;
                }
                {
                  name = "nvim/site/pack/plugins/start/diagflow-nvim";
                  path = pkgs.vimPlugins.diagflow-nvim;
                }
                {
                  name = "nvim/site/pack/plugins/start/nvim-treesitter";
                  path = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
                }
              ]
              ++ (map
                (x: {
                  name = "nvim/site/pack/plugins/start/nvim-treesitter-parsers-${x}";
                  path = pkgs.vimPlugins.nvim-treesitter-parsers.${x};
                })
                [
                  "lua"
                  "nix"
                  "rust"
                  "c"
                  "java"
                  "typst"
                  "python"
                  "javascript"
                  "typescript"
                  "html"
                  "css"
                  "bash"
                  "haskell"
                  "agda"
                  "markdown"
                ]
              )
            )
          );

          env.XDG_CONFIG_HOME = toString (
            pkgs.linkFarm "nvim-linkfarm" (
              [
                {
                  name = "nvim/init.lua";
                  path = ./init.lua;
                }
              ]
              ++ (map
                (x: {
                  name = "nvim/lua/plugins/${x}";
                  path = ./plugins/${x};
                })
                (
                  lib.mapAttrsToList (n: v: n) (
                    lib.filterAttrs (na: va: va == "regular" && lib.hasSuffix ".lua" na) (builtins.readDir ./plugins)
                  )
                )
              )
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
