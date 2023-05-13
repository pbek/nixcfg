# Astra TUG VM

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/mixins/users.nix
      ../../modules/mixins/desktop-common.nix
      ../../modules/mixins/audio.nix
      ../../modules/mixins/jetbrains.nix
      ../../modules/mixins/openssh.nix
      ../../modules/mixins/virt-manager.nix
#    ../../modules/editor/nvim.nix
    # this brought me an infinite recursion
#    mixins-openssh
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable grub cryptodisk
  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-c98e1bec-9e77-4107-bbcc-2be56cceb9d4".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "astra"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
