# Asus Rog Ally (using NixOS)

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.zfs.nix
    ../../modules/hokage
  ];

  networking = {
    hostName = "ally2";
    networkmanager.enable = true;
  };

  # Enable Tailscale VPN
  # Use `sudo tailscale up --accept-routes` to connect to the VPN
  services.tailscale.enable = true;

  hokage = {
    role = "ally";
    #    usePlasma6 = false;
    #    useWayland = false;
    #    termFontSize = 15.0;
    zfs = {
      enable = true;
      hostId = "decfda01";
    };
  };
}
