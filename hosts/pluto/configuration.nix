# PC Garage

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/mixins/users.nix
      ../../modules/mixins/desktop-x11.nix
      ../../modules/mixins/audio.nix
      ../../modules/mixins/jetbrains.nix
      ../../modules/mixins/openssh.nix
      ../../modules/mixins/virt-manager.nix
      ../../modules/mixins/local-store-cache.nix
#    ../../modules/editor/nvim.nix
    # this brought me an infinite recursion
#    mixins-openssh
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pluto"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Extract

  # https://nixos.wiki/wiki/VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ username ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # https://nixos.wiki/wiki/steam
#  programs.steam = {
#    enable = true;
#    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
#    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
#  };

  # https://nixos.wiki/wiki/nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.graphics.enable = true;
  hardware.nvidia.open = false;

  # The NVIDIA GeForce GTX 760 GPU needs the NVIDIA 470.xx Legacy drivers
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
  # hardware.nvidia.modesetting.enable = true;
}
