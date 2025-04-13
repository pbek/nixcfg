# netcup02 Netcup server
{
  modulesPath,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/mixins/server-remote.nix
    ./disk-config.zfs.nix
  ];

  networking = {
    hostName = "netcup02";
    networkmanager.enable = true;

    # ssh is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [
        25 # SMTP
        80 # HTTP
        443 # HTTPS
        587 # SMTP
      ];
    };
  };

  # Enable Netbird Wireguard VPN service
  services.netbird.enable = true;

  services.hokage = {
    zfs.hostId = "dafdad02";
  };
}
