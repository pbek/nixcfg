# netcup02 Netcup server
{ modulesPath, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/mixins/server-common.nix
      ./disk-config.zfs.nix
    ];

  # Bootloader.
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  services.zfs.autoScrub.enable = true;

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
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
    hostId = "daafda01";  # needed for ZFS
    hostName = "home01";
    networkmanager.enable = true;

    nameservers = ["192.168.1.1"];
    defaultGateway = "192.168.1.1";

#    interfaces.enp5s0 = {
#      ipv4.addresses = [{ address = "192.168.1.115"; prefixLength = 24; }];
#    };

    # SSH is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [
        53    # DNS
        80    # HTTP
        443   # HTTPS
        1880  # Node-RED Web UI
        1883  # MQTT
        2048  # Homeatic
        2049  # Homeatic
        8086  # InfluxDB
        8087  # Chronograf
        3000  # Grafana
        8090  # Tasmoadmin
        8070  # Calibre Web
        13378 # Audiobookshelf
        8200  # Photoprism
        8400  # Restic Rest Server
        8500  # Speedtest Tracker
        8050  # Attic
        8282  # Nix-Cache
        8383  # Zigbee2MQTT
      ];
      allowedUDPPorts = [
        53  # DNS
        67  # DHCP
        443 # HTTPS
      ];
    };
  };

  environment.systemPackages = with pkgs; [
  ];
}
