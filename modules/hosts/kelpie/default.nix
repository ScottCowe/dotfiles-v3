{ inputs, self, ... }:

{
  flake.nixosConfigurations.kelpie = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.kelpie-config
      self.nixosModules.kelpie-hardware
      self.nixosModules.kelpie-disks
      inputs.disko.nixosModules.disko
    ];
  };

  flake.nixosModules.kelpie-config =
    { pkgs, ... }:
    {
      boot.kernelParams = [ "boot.shell_on_fail" ];

      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;

      environment.systemPackages = with pkgs; [
        vim
        git
      ];

      users.users.admin = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$Mvu2t2DrKvPqr3AO$C3UtSVcm8DwWGmZjnUGt06V4i49b9HdWbD2ax.LOQLSj.t4tzVMWUPE0sF6gx6CRweu4hPKnOlVYb4iKq7mG.0";
      };

      security.sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };

      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };

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

      system.stateVersion = "25.11";

      i18n.defaultLocale = "en_US.UTF-8";

      time.timeZone = "London/Europe";
    };

  flake.nixosModules.kelpie-disks = {
    disko = {
      enableConfig = false;

      devices.disk.main = {
        type = "disk";
        imageSize = "8G";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
              priority = 0;
            };
            ESP = {
              type = "EF00";
              size = "1G";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0022"
                  "dmask=0022"
                ];
              };
            };
            root = {
              size = "100%";
              priority = 2;
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

    # TODO: Figure out why setting partition labels fails

    fileSystems."/" = {
      device = "/dev/vda3";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/vda2";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
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
        (modulesPath + "/profiles/qemu-guest.nix")
      ];

      boot.initrd.availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
