{ inputs, self, ... }:

{
  flake.nixosConfigurations.kelpie = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.kelpie-config
      self.nixosModules.kelpie-hardware
      self.nixosModules.kelpie-disks
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
    ];
  };

  flake.nixosModules.kelpie-config =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vim
        git
      ];

      users.users.admin = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$Mvu2t2DrKvPqr3AO$C3UtSVcm8DwWGmZjnUGt06V4i49b9HdWbD2ax.LOQLSj.t4tzVMWUPE0sF6gx6CRweu4hPKnOlVYb4iKq7mG.0";
        openssh.authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYSCl7s0xXsmax2bMqKYWEmIRYMRsYElflPS2/uwJ3x u0_a254@localhost"
        ];
      };

      security.sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking = {
        hostName = "kelpie";
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

      system.stateVersion = "26.05";

      i18n.defaultLocale = "en_US.UTF-8";

      time.timeZone = "London/Europe";
    };

  flake.nixosModules.kelpie-persist = {
    preservation = {
      enable = true;

      preserveAt."/persist" = {
        directories = [
          "/etc/nixos"
          "/lib/var/bluetooth"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
        ];

        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];
      };
    };
  };

  flake.nixosModules.kelpie-disks = {
    disko.devices.nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=25%"
          "mode=775"
        ];
      };
    };

    disko.devices.disk.main = {
      device = "/dev/sda";
      type = "disk";

      content.type = "gpt";

      content.partitions.boot = {
        name = "boot";
        size = "1M";
        type = "EF02";
      };

      content.partitions.esp = {
        name = "ESP";
        size = "1G";
        type = "EF00";

        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
      };

      content.partitions.swap = {
        size = "8G";

        content = {
          type = "swap";
          resumeDevice = true;
        };
      };

      content.partitions.root = {
        name = "root";
        size = "100%";

        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];

          subvolumes = {
            "/persist" = {
              mountOptions = [
                "subvol=persist"
                "noatime"
              ];
              mountpoint = "/persist";
            };
            "/nix" = {
              mountOptions = [
                "subvol=nix"
                "noatime"
              ];
              mountpoint = "/nix";
            };
          };
        };
      };
    };
  };

  flake.nixosModules.kelpie-hardware =
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
        "xhci_pci"
        "ahci"
        "ehci_pci"
        "usbhid"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
