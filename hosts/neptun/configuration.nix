# macBook

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # blacklist BCM43a0 Broadcom wifi
  # Wifi seems to still work and it seems much more stable
  boot.blacklistedKernelModules = [ "brcm80211" ];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Don't sleep when lid is closed
  # services.logind.lidSwitch = "ignore";

  # Allow insecure Broadcom driver
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-57-6.17.1"
  ];

  environment.systemPackages = with pkgs; [
    powertop
  ];

  hokage = {
    hostName = "neptun";
    lowBandwidth = true;
    cache.sources = [ "home" ];
  };
}
