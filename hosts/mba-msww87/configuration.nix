# mba-msww87 server
{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hokage
    ./disk-config.zfs.nix
  ];

  networking = {
    # SSH is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
        8883 # MQTT
      ];
      allowedUDPPorts = [
        443 # HTTPS
      ];
    };
  };

  users.users.gb = {
    openssh.authorizedKeys.keys = [
      # TODO: Gerhard public key
    ];
  };

  hokage = {
    hostName = "mba-msww87";
    users = [
      "mba"
      "gb"
    ];
    zfs.hostId = "cdbc4e20";
    serverMba.enable = true;
  };
}
