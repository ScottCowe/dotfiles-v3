{ inputs, self, ... }:

{
  flake.nixosConfigurations.heather = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.heather-disks
      self.nixosModules.heather-config
      self.nixosModules.cowedev
      inputs.disko.nixosModules.disko
    ];
  };

  flake.nixosModules.heather-config =
    {
      pkgs,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
      ];

      system.stateVersion = "25.05";
      nixpkgs.hostPlatform = "x86_64-linux";
      hardware.enableRedistributableFirmware = true;
      networking.hostName = "heather";
      time.timeZone = "UTC";

      networking = {
        interfaces.eth0 = {
          ipv4.addresses = [
            {
              address = "65.108.219.172";
              prefixLength = 24;
            }
          ];

          ipv6.addresses = [
            {
              address = "2a01:4f9:c012:6a09::1";
              prefixLength = 64;
            }
          ];
        };

        nameservers = [
          "185.12.64.1"
          "185.12.64.2"
        ];

        defaultGateway = {
          address = "172.31.1.1";
          interface = "eth0";
        };

        defaultGateway6 = {
          address = "fe80::1";
          interface = "eth0";
        };
      };

      boot.kernelParams = [ "net.ifnames=0" ];

      nix.settings = {
        trusted-users = [
          "@wheel"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      boot.loader.grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
      };

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

      environment.systemPackages = with pkgs; [
        vim
        git
      ];

      security.sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };

  flake.nixosModules.heather-disks = {
    disko.devices.disk.os = {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_101535789";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            type = "EF02";
            size = "1M";
          };
          ESP = {
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
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
}
