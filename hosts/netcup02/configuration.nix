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

  environment.systemPackages = with pkgs; [
  ];
}
