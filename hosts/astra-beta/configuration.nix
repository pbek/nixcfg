# Astra Beta
{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./disk-config.bcachefs.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable bcachefs filesystem support
  boot.supportedFilesystems = [ "bcachefs" ];
  boot.initrd.supportedFilesystems = [ "bcachefs" ];

  # Use latest kernel for bcachefs support, overriding hokage default
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  services.kmscon.enable = false;

  hokage = {
    hostName = "astra-beta";
    programs.espanso.enable = false; # Host will already use espanso
    # waylandSupport = false; # Disable Wayland support for clipboard sharing from guest to host
    waylandSupport = true;
    termFontSize = 16.0;
    programs.libvirt.role = "guest";
    cache.sources = [ "home" ];
    programs.jetbrains.enable = lib.mkForce false;
  };
}
