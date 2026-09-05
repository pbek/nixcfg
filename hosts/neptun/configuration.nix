# macBook

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  ...
}:

let
  broadcomSta = "broadcom-sta-6.30.223.271-63-7.2.3";
in

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
    broadcomSta
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_2;

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
    programs.jetbrains.enable = false;
  };
}
