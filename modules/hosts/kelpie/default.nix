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
      environment.systemPackages = with pkgs; [
        vim
        git
      ];

      users.users.admin = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      security.sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };

      boot.loader.systemd-boot.enable = true;

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
    disko.devices = {
      disk = {
        main = {
          device = "/dev/vda";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                type = "EF00";
                size = "1G";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              swap = {
                size = "2G";
                content = {
                  type = "swap";
                  discardPolicy = "both";
                  resumeDevice = true;
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
