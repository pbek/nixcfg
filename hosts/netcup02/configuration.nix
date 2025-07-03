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
    ../../modules/hokage
    ./disk-config.zfs.nix
  ];

  networking = {
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

  hokage = {
    hostName = "netcup02";
    role = "server-remote";
    zfs = {
      hostId = "dafdad02";
      # Reduce memory usage
      arcMax = 300 * 1024 * 1024;
    };
  };
}
