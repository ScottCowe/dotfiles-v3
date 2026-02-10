{ inputs, self, ... }:

{
  flake.nixosConfigurations.selkie = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.selkie-config
    ];
  };

  flake.nixosModules.selkie-config =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.selkie-hardware
        self.nixosModules.selkie-disks
        inputs.disko.nixosModules.disko
      ];

      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      environment.systemPackages = with pkgs; [
        vim
        git
      ];

      services.tailscale.enable = true;

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        };
      };

      users.users.admin = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJJLV+VlVk+vyV1NBkPxtEGo+MfDzwy7rWenK7DN2tX1 cowe@framework"
        ];
      };

      services.xserver = {
        enable = true;
        desktopManager = {
          xterm.enable = false;
          xfce.enable = true;
        };
      };

      services.displayManager.defaultSession = "xfce";

      security.sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };

      boot.loader.systemd-boot.enable = true;

      networking = {
        hostName = "selkie";
        networkmanager.enable = true;
      };

      nix.settings = {
        trusted-users = [
          "@wheel"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      system.stateVersion = "25.05";

      i18n.defaultLocale = "en_US.UTF-8";

      time.timeZone = "London/Europe";

      users.users."jam" = {
        isNormalUser = true;
        initialPassword = "password";
      };
    };

  flake.nixosModules.selkie-disks = {
    disko.devices = {
      disk = {
        main = {
          device = "/dev/disk/by-id/ata-Samsung_SSD_870_QVO_1TB_S5RRNF0R590558R";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                type = "EF00";
                size = "100M";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
  };

  flake.nixosModules.selkie-hardware =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "ahci"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];

      networking.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
