# netcup01 Netcup server
{
  modulesPath,
  config,
  pkgs,
  ...
}:
let
  userLogin = config.services.hokage.userLogin;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/mixins/server-remote.nix
    ./disk-config.zfs.nix
  ];

  # Bootloader.
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      {
        devices = [ "nodev" ];
        path = "/boot";
      }
    ];
  };

  boot.initrd.network = {
    enable = true;
    postCommands = ''
      sleep 2
      zpool import -a;
    '';
  };

  networking = {
    hostId = "dafdad01"; # needed for ZFS
    hostName = "netcup01";
    networkmanager.enable = true;

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

  services.hokage = {
    useSecrets = false;
  };
}
