# TU HP EliteBook Laptop 840 G5

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

  # For testing https://gitlab.tugraz.at/vpu-private/ansible/
  virtualisation.multipass.enable = true;

  # Increase the console font size for kmscon
  services.kmscon.extraConfig = "font-size = 18";

  hokage = {
    hostName = "sinope";
    tugraz.enable = true;
    jetbrains = {
      goland.enable = false;
    };
    languages.cplusplus.enable = false;
    cache.sources = [ "caliban" ];
  };
}
