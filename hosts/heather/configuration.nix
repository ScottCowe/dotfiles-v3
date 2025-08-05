{
  self,
  inputs,
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    # ./nginx.nix
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
        }
      ];

      ipv6.addresses = [
        {
          address = "2a01:4f9:c012:6a09::1";
        }
      ];
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
}
