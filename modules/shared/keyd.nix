{
  flake.nixosModules.keyd = {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              esc = "`";
              capslock = "overload(nav, esc)";
            };
            nav = {
              esc = "capslock";
              h = "left";
              j = "down";
              k = "up";
              l = "right";
            };
          };
        };
      };
    };
  };
}
