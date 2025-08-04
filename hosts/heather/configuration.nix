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
  ];

  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  networking.hostName = "heather";
  time.timeZone = "UTC";

  networking.useDHCP = true;

  boot.kernelParams = [ "net.ifnames=0" ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJJLV+VlVk+vyV1NBkPxtEGo+MfDzwy7rWenK7DN2tX1 cowe@framework"
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  programs.bash.enableCompletion = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
