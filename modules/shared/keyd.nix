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
              "1" = "f1";
              "2" = "f2";
              "3" = "f3";
              "4" = "f4";
              "5" = "f5";
              "6" = "f8";
              "7" = "f7";
              "8" = "f8";
              "9" = "f9";
              "0" = "f10";
            };
          };
        };
      };
    };
  };
}
