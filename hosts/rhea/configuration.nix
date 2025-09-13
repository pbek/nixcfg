# Asus Vivobook Laptop

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{

  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/hokage
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Restart network and docker after suspend
  # I had issues with KDE Plasma detecting that there is network after suspend
  powerManagement.resumeCommands = ''
    nmcli n off
    nmcli n on
    systemctl restart docker
  '';

  hokage = {
    hostName = "rhea";
    lowBandwidth = true;
    useGhosttyGtkFix = false;
    cache.sources = [ "home" ];
  };
}
