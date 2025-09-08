# Astra TUG VM

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/hokage
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
  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."luks-c98e1bec-9e77-4107-bbcc-2be56cceb9d4".keyFile =
    "/crypto_keyfile.bin";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable Tailscale VPN
  # Use `sudo tailscale up --accept-routes` to connect to the VPN
  # services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
  ];

  services.kmscon.enable = false;

  hokage = {
    hostName = "astra";
    espanso.enable = false; # Host will already use espanso
    waylandSupport = false; # Disable Wayland support for clipboard sharing from guest to host
    termFontSize = 16.0;
    useGhosttyGtkFix = false;
    virtManager.role = "guest";
    cache.sources = [ "caliban" ];
  };
}
