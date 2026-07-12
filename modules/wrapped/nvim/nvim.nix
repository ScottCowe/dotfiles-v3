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

          startPlugins = with pkgs.vimPlugins; [ kanagawa-nvim ];

          packpath = pkgs.runCommandLocal "packpath" { } ''
            mkdir -p $out/pack/${packageName}/{start,opt}

            ${lib.concatMapStringsSep "\n" (
              plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}"
            ) startPlugins}
          '';
        in
        (pkgs.symlinkJoin {
          name = "nvim";
          paths = [ pkgs.neovim-unwrapped ];
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
