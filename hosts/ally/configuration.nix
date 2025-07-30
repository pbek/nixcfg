# Asus Rog Ally (usually using Windows)

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/hokage
  ];

  hokage = {
    role = "ally";
    hostName = "ally";
    useSecrets = false;
    zfs = {
      enable = true;
      hostId = "3f2e973f";
      encrypted = false;
    };
  };
}
