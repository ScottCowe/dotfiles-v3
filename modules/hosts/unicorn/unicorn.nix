{ inputs, self, ... }:

{
  flake.nixosConfigurations.unicorn = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.unicorn-config
      self.nixosModules.unicorn-hardware
      self.nixosModules.unicorn-disks
      self.nixosModules.unicorn-persist

      self.nixosModules.keyd
      self.nixosModules.nvim
      self.nixosModules.git
      self.nixosModules.devenv
      self.nixosModules.ly
      self.nixosModules.thunderbird
      self.nixosModules.mako
      self.nixosModules.discord
      self.nixosModules.prismlauncher
      self.nixosModules.mullvad
      self.nixosModules.hyprland
      self.nixosModules.librewolf
      self.nixosModules.steam
      self.nixosModules.persistance
      self.nixosModules.bluetooth
      self.nixosModules.claude-code
      self.nixosModules.openrocket
      self.nixosModules.vlc

      inputs.disko.nixosModules.disko
    ];
  };

  flake.nixosModules.unicorn-config =
    { pkgs, ... }:
    {
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
      };

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
        pavucontrol
        brightnessctl
        eza
      ];

      services.gnome.gnome-keyring.enable = true;
      security.polkit.enable = true;

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
        hostName = "unicorn";
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

      nixpkgs.config.allowUnfree = true;

      system.stateVersion = "26.05";

      i18n.defaultLocale = "en_US.UTF-8";

      services.automatic-timezoned.enable = true;

      fonts.packages =
        with pkgs;
        [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          liberation_ttf
          fira-code
          fira-code-symbols
          mplus-outline-fonts.githubRelease
          dina-font
          proggyfonts
        ]
        ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));
    };

  flake.nixosModules.unicorn-persist = {
    persistance.enable = true;

    persistance.dirs = [
      "/etc/NetworkManager/system-connections/"
    ];

    persistance.user = "cowe";
    persistance.userDirs = [
      ".ssh"
      "repos"
      ".local/state/wireplumber"
    ];
  };

  flake.nixosModules.unicorn-disks = {
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
      device = "/dev/nvme0n1";

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
        size = "32G";

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

  flake.nixosModules.unicorn-hardware =
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
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
