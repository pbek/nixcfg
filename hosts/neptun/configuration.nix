# macBook

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ./disk-config.zfs.nix
  ];

  # blacklist BCM43a0 Broadcom wifi
  # Wifi seems to still work and it seems much more stable
  boot.blacklistedKernelModules = [ "brcm80211" ];

  # Don't sleep when lid is closed
  # services.logind.lidSwitch = "ignore";

  # Allow insecure Broadcom driver
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.19.6"
  ];

  environment.systemPackages = with pkgs; [
    powertop
  ];

  hokage = {
    hostName = "neptun";
    lowBandwidth = true;
    cache.sources = [ "home" ];
    zfs = {
      enable = true;
      hostId = "c15661e7";
      encrypted = true;
    };
  };
}
