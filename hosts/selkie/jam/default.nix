{ inputs, ... }:

{
  users.users."jam" = {
    isNormalUser = true;
    initialPassword = "password";
  };

  home-manager.extraSpecialArgs = {
    inherit inputs;
  };

  home-manager.users."jam" = {
    home.stateVersion = "25.05";
    home.username = "jam";
    home.homeDirectory = "/home/jam";

    imports = [
      ./firefox.nix
    ];
  };
}
