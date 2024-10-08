# home01 server
{ modulesPath, config, pkgs, username, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/mixins/server-local.nix
      ../../modules/mixins/local-store-cache.nix
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

    interfaces.enp3s0 = {
      ipv4.addresses = [{ address = "192.168.1.115"; prefixLength = 24; }];
    };

    # Add local hostname to /etc/hosts so that it can be resolved for the binary cache
    hosts = {
      "192.168.1.115" = [ "home01.lan" ];
    };

    # SSH is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [
        53    # DNS
        80    # HTTP
        443   # HTTPS
        1234  # Homepage
        1880  # Node-RED Web UI
        1883  # MQTT
        2048  # Homeatic
        2049  # Homeatic
        4533  # Navidrome
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
        8384  # Zigbee2MQTT2
      ];
      allowedUDPPorts = [
        53  # DNS
        67  # DHCP
        443 # HTTPS
        2048  # Homeatic
        2049  # Homeatic
      ];
    };
  };

  # Increase ulimit for influxdb
  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "8192";
  }];

  # Enable Fwupd
  # https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  # Enable Netbird Wireguard VPN service
  services.netbird.enable = true;

  # Enable Tailscale VPN
  # Use `sudo tailscale up --advertise-exit-node --advertise-routes=192.168.1.0/24`
  # But did cause DNS troubles in docker containers!
#  services.tailscale.enable = true;
#  services.tailscale.useRoutingFeatures = "both";

  # Enable Nix-Cache
  # See ./README.md
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/etc/cache-priv-key.pem";
    openFirewall = true;
  };

  systemd.services = {
    nixcfg-autobuild = {
      description = "Timer for automated NixOS configuration build";
      path = [
        pkgs.nixos-rebuild
      ];
      script = "nixos-rebuild build --flake github:pbek/nixcfg#venus";
      serviceConfig = {
        User = username;
      };
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
      # Use `systemd-analyze calendar "*-*-* 5,7,8,9,12,15,16,18,21:00:00"` to test
      startAt = "*-*-* 5,7,8,9,12,15,16,18,21:00:00";
    };
  };

  environment.systemPackages = with pkgs; [
  ];
}
