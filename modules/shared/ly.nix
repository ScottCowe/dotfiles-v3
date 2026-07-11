{
  flake.nixosModules.ly = {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
      };
    };
  };
}
