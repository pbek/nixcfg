# netcup02 Netcup server
{ config, pkgs, ... }:

{
  imports =
    [
#      ./hardware-configuration.nix
      ../../modules/mixins/server-common.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Enable networking
  networking.networkmanager.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 25 ]; # SMTP
  };

  networking = {
    hostName = "netcup02";
    networkmanager.enable = true;

    interfaces.eth0 = {
      ipv4.addresses = ["192.168.1.100/24"];
#      ipv4.addresses = ["2.56.98.9/22"];
      ipv4.gateway = "192.168.1.1";
#      ipv4.gateway = "2.56.96.1";
    };

    # ssh is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [ 25 ]; # SMTP
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
  ];
}
