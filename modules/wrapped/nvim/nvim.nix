{ self, ... }:
{
  flake.nixosModules.nvim = { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.custom-nvim;
    };
  };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.custom-nvim =
        let
          packageName = "thing";

          lsps = with pkgs; [
            lua-language-server
            nixd
            nixfmt
            rust-analyzer
            resvg
            typescript-language-server
            svelte-language-server
          ];

          startPlugins = with pkgs.vimPlugins; [
            nvim-treesitter.withAllGrammars
            kanagawa-nvim
            lualine-nvim
            blink-cmp
            gitsigns-nvim
            nvim-autopairs
            indent-blankline-nvim
            lean-nvim
            plenary-nvim
            nvim-ts-autotag
          ];

          foldPlugins = builtins.foldl' (
            acc: next:
            acc
            ++ [
              next
            ]
            ++ (foldPlugins (next.dependencies or [ ]))
          ) [ ];

          startPluginsWithDeps = lib.unique (foldPlugins startPlugins);

          packpath = pkgs.runCommandLocal "packpath" { } ''
            mkdir -p $out/pack/${packageName}/{start,opt}

            ${lib.concatMapStringsSep "\n" (
              plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}"
            ) startPluginsWithDeps}
          '';
        in
        (pkgs.symlinkJoin {
          name = "nvim";
          paths = [ pkgs.neovim-unwrapped ] ++ lsps;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/nvim \
                  --add-flags '-u' \
                  --add-flags '${./init.lua}' \
                  --add-flags '--cmd' \
                  --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath}'" \
                  --set-default NVIM_APPNAME nvim-custom
          '';

          passthru = {
            inherit packpath;
          };

          meta = {
            inherit (pkgs.neovim-unwrapped.meta)
              description
              longDescription
              homepage
              mainProgram
              license
              teams
              platforms
              ;
          };
        });
    };
}
