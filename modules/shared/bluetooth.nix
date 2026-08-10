{
  flake.nixosModules.bluetooth = {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    services.blueman.enable = true;

    hardware.bluetooth.settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };

    persistance.dirs = [ "/lib/var/bluetooth" ];
    persistance.userDirs = [ ".config/dconf" ];
  };
}
