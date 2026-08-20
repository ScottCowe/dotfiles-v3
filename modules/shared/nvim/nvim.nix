{ self, ... }:
{
  flake.nixosModules.nvim = { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.nvim;
    };
  };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.nvim =
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

          runtimepath = pkgs.runCommandLocal "nvim-runtimepath" { } ''
            mkdir -p $out
            cp ${./init.lua} $out/init.lua

            mkdir -p $out/lsp

            ${lib.concatMapStringsSep "\n" (lsp: "cp ${./lsp/${lsp}} $out/lsp/${lsp}") (
              lib.mapAttrsToList (n: v: n) (
                lib.filterAttrs (na: va: va == "regular" && lib.hasSuffix ".lua" na) (builtins.readDir ./lsp)
              )
            )}
          '';
        in
        pkgs.symlinkJoin {
          name = "nvim";
          paths = [ pkgs.neovim-unwrapped ] ++ lsps;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/nvim \
                  --add-flags '-u' \
                  --add-flags '${runtimepath}/init.lua' \
                  --add-flags '--cmd' \
                  --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath}'" \
                  --add-flags '--cmd' \
                  --add-flags "'set runtimepath^=${runtimepath}'" \
                  --set-default NVIM_APPNAME nvim
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
        };
    };
}
