{ self, inputs, ... }:
{
  perSystem =
    { pkgs, self', ... }:
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
            pkgs.linkFarm "nvim-linkfarm" [
              {
                name = "nvim/init.lua";
                path = ./init.lua;
              }
              {
                name = "nvim/lua/plugins/lualine.lua";
                path = ./lua/plugins/lualine.lua;
              }
              {
                name = "nvim/lsp/lua.lua";
                path = ./lsp/lua.lua;
              }
              {
                name = "nvim/lsp/nix.lua";
                path = ./lsp/nix.lua;
              }
              {
                name = "nvim/pack/vendor/start/lualine.nvim";
                path = pkgs.vimPlugins.lualine-nvim;
              }
            ]
          );
        }
      );
    };
}
