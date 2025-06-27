# Astra TUG VM

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
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
  networking.hostName = "astra"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable Tailscale VPN
  # Use `sudo tailscale up --accept-routes` to connect to the VPN
  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
  ];

  services.kmscon.enable = false;

  hokage = {
    espanso.enable = false; # App-specific configurations are not yet supported in Wayland on caliban for VirtualBox!
    waylandSupport = false;
    termFontSize = 16.0;
    usePlasma6 = true;
    useGhosttyGtkFix = false;
    virtualbox = {
      enable = true;
      role = "guest";
    };
    cache.sources = [ "caliban" ];
  };
}
