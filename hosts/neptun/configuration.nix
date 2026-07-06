# macBook

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  pkgs,
  system,
  ...
}:

let
  broadcomSta = "broadcom-sta-6.30.223.271-59-7.0.14";
  zfsPkgs = import inputs.nixpkgs-zfs {
    inherit system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ broadcomSta ];
    };
  };
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

  # Keep the pinned ZFS kernel host-local so Broadcom STA uses the same
  # insecure-package exception as this host.
  boot.kernelPackages = zfsPkgs.linuxKernel.packages.linux_7_0;

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
