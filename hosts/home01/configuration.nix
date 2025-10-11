# home01 server
{
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
    nameservers = [ "192.168.1.1" ];
    defaultGateway = "192.168.1.1";

    interfaces.enp3s0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.115";
          prefixLength = 24;
        }
      ];
    };

    # Add local hostname to /etc/hosts so that it can be resolved for the binary cache
    hosts = {
      "192.168.1.115" = [ "home01.lan" ];
      "192.168.1.103" = [ "camerapi.lan" ];
    };

    # SSH is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [
        53 # DNS
        80 # HTTP
        443 # HTTPS
        1234 # Homepage
        1880 # Node-RED Web UI
        1883 # MQTT
        2048 # Homeatic
        2049 # Homeatic
        4533 # Navidrome
        8086 # InfluxDB
        8087 # Chronograf
        3000 # Grafana
        8090 # Tasmoadmin
        8070 # Calibre Web
        13378 # Audiobookshelf
        8200 # Photoprism
        8400 # Restic Rest Server
        8500 # Speedtest Tracker
        8050 # Attic
        8282 # Nix-Cache
        8383 # Zigbee2MQTT
        8384 # Zigbee2MQTT2
      ];
      allowedUDPPorts = [
        53 # DNS
        67 # DHCP
        443 # HTTPS
        2048 # Homeatic
        2049 # Homeatic
      ];
    };
  };

  # Increase ulimit for influxdb
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "8192";
    }
  ];

  # Enable Fwupd
  # https://wiki.nixos.org/wiki/Fwupd
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
      script = ''
        nixos-rebuild build --flake github:pbek/nixcfg#venus
        nixos-rebuild build --flake github:pbek/nixcfg#gaia
        nixos-rebuild build --flake github:pbek/nixcfg#pluto
      '';
      serviceConfig = {
        User = "root";
      };
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html
      # Use `systemd-analyze calendar "*-*-* 5,7,8,9,12,15,16,18,21:00:00"` to test
      startAt = "*-*-* 5,7,8,9,12,15,16,18,21:00:00";
    };

    # Monitor Wireguard UDP port 51821 on camerapi.lan and report to Uptime Kuma
    camerapi-wireguard-monitor = {
      description = "Monitor Wireguard on camerapi.lan";
      path = with pkgs; [
        nmap
        curl
      ];
      script = ''
        #!/bin/bash
        set -e

        UPTIME_KUMA_URL="http://cicinas2.lan:8130/api/push/HeUH8QHFMsj0yZZEqB8wuutNqCUQBoFz"

        # Test UDP port 51821 on camerapi.lan using nmap
        if timeout 30 nmap -sU -p 51821 -Pn -n --reason camerapi.lan | grep -q "51821/udp open"; then
          # Port is open - send success status
          curl -s "$UPTIME_KUMA_URL?status=up&msg=UDP_51821_Open&ping=0" || true
          echo "Port 51821/udp is open on camerapi.lan - reported success to Uptime Kuma"
        else
          # Port is closed or filtered - send failure status
          curl -s "$UPTIME_KUMA_URL?status=down&msg=UDP_51821_Closed&ping=0" || true
          echo "Port 51821/udp is closed/filtered on camerapi.lan - reported failure to Uptime Kuma"
        fi
      '';
      serviceConfig = {
        User = "root";
      };
      # Run every 10 minutes
      startAt = "*:0/10";
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  hokage = {
    hostName = "home01";
    role = "server-home";
    programs.libvirt.enable = true;
    zfs.hostId = "daafda01";
    cache.sources = [ "home" ];
  };
}
