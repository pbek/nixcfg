# Gaia Office Work PC

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, username, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/mixins/users.nix
      ../../modules/mixins/desktop.nix
      ../../modules/mixins/audio.nix
      ../../modules/mixins/platformio.nix
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
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "gaia"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # Samsung printer driver for ML-1710
  services.printing.drivers = [ pkgs.splix ];

  environment.systemPackages = with pkgs; [
    calibre
    arduino-ide
    g810-led # Logitech G213 keyboard
    kdePackages.kdialog
    bitscope.meter
    bitscope.dso
    bitscope.logic
    blender
    cura
    go-passbolt-cli
#    (pkgs.callPackage ../../apps/go-passbolt-cli/default.nix { })
  ];

  # Handle keyboard leds
  powerManagement.powerUpCommands = ''
    ${pkgs.g810-led}/bin/g213-led -r 1 ff0000     # Set color of zone 1 to red
    ${pkgs.g810-led}/bin/g213-led -r 2 ff0000     # Set color of zone 2 to red
    ${pkgs.g810-led}/bin/g213-led -r 3 ff0000     # Set color of zone 3 to red
    ${pkgs.g810-led}/bin/g213-led -r 4 7fff00     # Set color of zone 4 to green
    ${pkgs.g810-led}/bin/g213-led -r 5 7fff00     # Set color of zone 5 to green
  '';

  # Extract

  # https://github.com/NixOS/nixpkgs/issues/215450
  # users.users.${username} = {
  #   packages = with pkgs; [
  #     playwright
  #     (runCommand "wrapped-playwright" { buildInputs = [ makeWrapper ]; } ''
  #     mkdir -p "$out/bin"
  #     makeWrapper "${playwright}/bin/playwright" "$out/bin/playwright" \
  #       --set PLAYWRIGHT_BROWSERS_PATH "${playwright-driver.browsers}"
  #     '')
  #   ];
  # };

  # https://nixos.wiki/wiki/VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ username ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # Try to get get around: /nix/store/lx50avim6rzf20b69q4zwak07c479qwp-udev-rules/60-openocd.rules:188 Unknown group 'plugdev', ignoring.
  # https://github.com/NixOS/nixpkgs/issues/81326#issuecomment-592790668
  users.users.${username} = {
    extraGroups = [ "plugdev" ];
  };

  # https://nixos.wiki/wiki/steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # https://nixos.wiki/wiki/nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.graphics.enable = true;

  # The NVIDIA GeForce GTX 760 GPU needs the NVIDIA 470.xx Legacy drivers
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
  hardware.nvidia.modesetting.enable = true;
}
