{ inputs, self, ... }:

{
  flake.nixosConfigurations.kelpie = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.kelpie-config
      self.nixosModules.kelpie-hardware
      self.nixosModules.kelpie-disks
      self.nixosModules.kelpie-persist

      self.nixosModules.niri
      # self.nixosModules.neovim

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

      users.users.root.initialHashedPassword = "$6$UCZpm1HfGnxZ67Rd$FkLVhuL996Y3RE59UHXldEOe4dJaBXnDval0qh3gYRT9dFcJPTn7cjsPRwXBXrUZR/eypSsevho7fBqGomITx0";

      users.users.cowe = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        initialHashedPassword = "$6$UCZpm1HfGnxZ67Rd$FkLVhuL996Y3RE59UHXldEOe4dJaBXnDval0qh3gYRT9dFcJPTn7cjsPRwXBXrUZR/eypSsevho7fBqGomITx0";
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
    systemd.services.systemd-machine-id-commit = {
      unitConfig.ConditionPathIsMountPoint = [
        ""
        "/persist/etc/machine-id"
      ];
      serviceConfig.ExecStart = [
        ""
        "systemd-machine-id-setup --commit --root /persist"
      ];
    };

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
          "/etc/NetworkManager/system-connections/"
        ];

        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
            how = "symlink";
          }
        ];

        users.cowe = {
          directories = [
            ".ssh"
            "repos"
          ];

          files = [ ];
        };
      };
    };
  };

  flake.nixosModules.kelpie-disks = {
    fileSystems."/nix".neededForBoot = true;
    fileSystems."/persist".neededForBoot = true;

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
      device = "/dev/disk/by-id/ata-SanDisk_SD9SN8W256G1014_192674806388";

      type = "disk";
      content.type = "gpt";

      content.partitions.esp = {
        size = "1G";
        type = "EF00";

        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
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
