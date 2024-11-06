# TU "Guest" HP EliteBook Laptop 840 G5

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, userLogin, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/mixins/users.nix
      ../../modules/mixins/desktop.nix
      ../../modules/mixins/audio.nix
      ../../modules/mixins/jetbrains.nix
      ../../modules/mixins/openssh.nix
      ../../modules/mixins/remote-store-cache.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-0eda41dc-43e4-4a37-92ac-b33be4c24d4f".device = "/dev/disk/by-uuid/0eda41dc-43e4-4a37-92ac-b33be4c24d4f";

  networking.hostName = "dp01"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    go-passbolt-cli
  ];
}
