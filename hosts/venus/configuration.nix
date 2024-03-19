# Livingroom PC

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/mixins/users.nix
#      ../../modules/mixins/desktop-x11.nix
      ../../modules/mixins/desktop.nix
      ../../modules/mixins/audio.nix
      ../../modules/mixins/jetbrains.nix
      ../../modules/mixins/openssh.nix
      ../../modules/mixins/virt-manager.nix
      ../../modules/mixins/local-store-cache.nix
#      ../../modules/mixins/remote-store-cache.nix
#    ../../modules/editor/nvim.nix
    # this brought me an infinite recursion
#    mixins-openssh
    ];

  # Bootloader
  # Getting the bootloader to detect Windows didn't work, use F12 at boot for a boot manager
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.device = "nodev";
  # boot.loader.grub.useOSProber = true;
  # boot.loader.grub.extraEntries = ''
  #   menuentry "Windows 10" {
  #     chainloader (hd0,gpt2)+1
  #   }
  # '';

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "venus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  networking.hosts = {
    "192.168.1.110" = [ "cicinas" "cicinas.lan" ];
    "192.168.1.111" = [ "cicinas2" "cicinas2.lan" ];
  };

  environment.systemPackages = with pkgs; [
    calibre
    zoom-us
    blender
    cura
  ];

  # https://nixos.wiki/wiki/nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;

  # Wayland
#  services.xserver.displayManager.defaultSession = "plasmawayland";
#  # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
#  home-manager.users.${username} = {
#    # https://mynixos.com/home-manager/options/services.espanso
#    services.espanso = {
#      package = pkgs.espanso-wayland;
#    };
#  };

  # Enable suspend to RAM
  # Sleep is hindered by a compontent on the motherboard
  # Problem with "00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge"
  powerManagement.powerUpCommands = ''
    echo GPP0 > /proc/acpi/wakeup
  '';
  # powerManagement.powerDownCommands = ''
  #   echo GPP0 > /proc/acpi/wakeup
  # '';

  # https://nixos.wiki/wiki/VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ username ];
}
