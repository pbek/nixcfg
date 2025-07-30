# netcup01 Netcup server
{
  config,
  pkgs,
  ...
}:
let
  inherit (config.hokage) userLogin;
in
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
        25 # SMTP
        80 # HTTP
        143 # IMAP
        443 # HTTPS
        587 # SMTP
        993 # IMAPS
        4190 # ManageSieve
        8883 # MQTT
      ];
      allowedUDPPorts = [
        443 # HTTPS
      ];
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  # Fixes issue with updating the OwnNotes releases RSS feed
  systemd.services.restart-qownnotes = {
    description = "Restart QOwnNotes Docker Compose services";
    script = ''
      set +e  # Don't exit on error
      ${pkgs.docker-compose}/bin/docker-compose rm -f -s -v qownnotes-api
      ${pkgs.docker-compose}/bin/docker-compose rm -f -s -v qownnotes-webpage
      ${pkgs.docker-compose}/bin/docker-compose up -d qownnotes-api qownnotes-webpage
    '';
    serviceConfig = {
      Type = "oneshot";
      User = userLogin;
      WorkingDirectory = "/home/omega/server";
    };
  };

  systemd.timers.restart-qownnotes = {
    wantedBy = [ "timers.target" ];
    partOf = [ "restart-qownnotes.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 08:00:00";
      Persistent = true;
    };
  };

  hokage = {
    hostName = "netcup01";
    role = "server-remote";
    zfs.hostId = "dafdad01";
  };
}
