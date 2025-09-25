# miniserver24 server for Markus
{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hokage
    ./disk-config.zfs.nix
  ];

  # Allow unfree package for "FLIRC" IR-USB-Module
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "flirc"
    ];

  # Enable local APC UPS monitoring
  # Notes
  #     - The header '## apcupsd.conf v1.1 ##' with a comment is added by NixOS at the beginning
  #     - We do not need the SCRIPTDIR but it is aded by NixOS too with something like
  #       'SCRIPTDIR /nix/store/randomcharacters-apcupsd-scriptdir'
  services.apcupsd = {
    enable = true;
    configText = ''
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
    '';
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # ZFS configuration
  services.zfs.autoScrub.enable = true;

  # Networking configuration
  networking = {
    # nameservers = ["1.1.1.1"]; # We utilize an external DNS server to ensure web access at boot time, prior to the Pi-hole becoming operational.
    nameservers = [ "localhost" ]; # Many services (docker container) depend on internal hostnames, so we need to use local DNS
    search = [ "lan" ];
    defaultGateway = "192.168.1.5";
    hosts = {
      "192.168.1.32" = [
        "kr-sonnen-batteriespeicher"
        "kr-sonnen-batteriespeicher.lan"
      ];
      "192.168.1.102" = [
        "vr-opus-gateway"
        "vr-opus-gateway.lan"
      ];
      "192.168.1.159" = [
        "wz-pixoo-64-00"
        "wz-pixoo-64-00.lan"
      ];
      "192.168.1.189" = [
        "wz-pixoo-64-01"
        "wz-pixoo-64-01.lan"
      ];
    };
    interfaces.enp3s0f0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.101";
          prefixLength = 24;
        }
      ];
    };
    # Firewall configuration
    firewall = {
      enable = false; # Firewall is disabled due to homekit issues (may be revisited later, so we keep settings)
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
        1880 # Node-RED Web UI
        1883 # MQTT
        9000 # Portainer web
        51827 # HomeKit accessory communication
        554 # HomeKit Secure Video RTSP
        5223 # HomeKit notifications (APNS, Apple Push Notification Service)
      ];
      allowedUDPPorts = [
        443 # HTTPS
        5353 # mDNS for HomeKit: Bonjour discovery and CIAO
      ];
    };
  };

  # Disable fail2ban since firewall is turned off
  services.fail2ban.enable = false;

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
  # https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  # Enable FLIRC IR-USB-Module
  hardware.flirc.enable = true;
  users.users.mba.extraGroups = [ "plugdev" ];

  # Additional system packages
  environment.systemPackages = with pkgs; [
    # Network-related packages
    samba # Enables remote shutdown of Windows PC via Node-RED and HomeKit voice command
    wol # Facilitates wake-on-LAN for Windows 10 PC in Node-RED, triggered by HomeKit voice command
    mosquitto # Only for mosquitto_sub on system level
    usbutils # Provides lsusb and other USB utilities
    #flirc-bin # Command line tool for programming FLIRC
    evtest # For testing input device events
    ## --------------------------------------
    # Packages for kiosk-mode-vlc-cam viewer
    # Note: Packages vlc, openbox, xorg.xset
    #   work together to create a kiosk-mode
    #   camera viewer
    ## --------------------------------------
    vlc # Video playback software
    openbox # Lightweight window manager
    xorg.xset # X11 user preference utility tool
    pulseaudio # To enable audio forwarding to a homepod
  ];

  # +X11 and VLC kiosk mode configuration
  # Note: For start script go to: /home/kiosk/.config/openbox/autostart
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    windowManager.openbox.enable = true;
  };
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "kiosk";
    };
    defaultSession = "none+openbox";
  };

  # Configuration for user "kiosk"
  users.users.kiosk = {
    isNormalUser = true;
    description = "Kiosk User";
    extraGroups = [
      "video"
      "audio"
    ];
    hashedPassword = "!";
    home = "/home/kiosk";
    createHome = true;
  };

  # Home Manager configuration for the kiosk user
  home-manager.users.kiosk = {
    home.stateVersion = "23.11";
    # Ensure necessary packages are available to the kiosk user
    home.packages = with pkgs; [
      vlc
      xorg.xset
    ];
  };

  # APC UPS MQTT periodic publishing
  systemd.services.apc-to-mqtt = {
    description = "Publish APC UPS status to MQTT";
    script = "/home/mba/scripts/apc-to-mqtt.sh";
    serviceConfig = {
      Type = "oneshot";
      User = "mba";
      Environment = "PATH=/run/current-system/sw/bin";
    };
  };

  systemd.timers.apc-to-mqtt = {
    description = "Timer for APC UPS MQTT publishing";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1min"; # every 1 minutes
      Unit = "apc-to-mqtt.service";
    };
  };

  # MQTT-based VLC Volume Control Service for NixOS
  #
  # This service listens for MQTT messages on the topic 'home/miniserver24/kiosk-vlc-volume'
  # and uses the received value to control VLC's volume via telnet.
  #
  # Features:
  # - Securely reads MQTT credentials from an environment file
  # - Validates incoming volume values (range: 0-512)
  # - Controls VLC volume using a Tapo camera password for authentication
  # - Comprehensive logging for easy troubleshooting
  #
  # Dependencies:
  # - Requires mosquitto_sub, sed, and netcat packages
  # - Expects MQTT credentials in /etc/secrets/mqtt.env
  # - Expects Tapo camera password in /etc/secrets/tapoC210-00.env
  # - Assumes VLC is running and listening on localhost:4212 for telnet connections
  #
  # Usage:
  # 1. Ensure VLC is running with telnet interface enabled
  # 2. Publish a message to 'home/miniserver24/kiosk-vlc-volume' with a value between 0 and 512
  # 3. The service will set VLC's volume accordingly and log the action
  #
  # Logging:
  # - All actions are logged to systemd journal with identifier 'mqtt-volume-control'
  # - View logs with: journalctl -t mqtt-volume-control -f

  systemd.services.mqtt-volume-control = {
    description = "MQTT-based VLC Volume Control Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      MQTT_ENV_FILE = "/etc/secrets/mqtt.env";
      TAPO_ENV_FILE = "/etc/secrets/tapoC210-00.env";
    };

    serviceConfig = {
      ExecStart = pkgs.writeShellScript "mqtt-volume-control" ''
        # Enhanced logging function with timestamps
        log() {
          echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | ${pkgs.systemd}/bin/systemd-cat -t mqtt-volume-control -p info
        }

        # Log script start
        log "Script starting. Attempting to source MQTT environment variables."

        # Source MQTT environment variables
        if [ -f "$MQTT_ENV_FILE" ]; then
          if [ -r "$MQTT_ENV_FILE" ]; then
            set -a
            source "$MQTT_ENV_FILE"
            set +a
            log "MQTT environment variables sourced successfully."
            log "DEBUG: MQTT_HOST=$MQTT_HOST, MQTT_USER=$MQTT_USER"

            # Validate that required variables are set
            if [ -z "$MQTT_HOST" ] || [ -z "$MQTT_USER" ] || [ -z "$MQTT_PASS" ]; then
              log "ERROR: One or more required MQTT variables are not set. Please check $MQTT_ENV_FILE"
              exit 1
            fi
          else
            log "ERROR: MQTT environment file is not readable: $MQTT_ENV_FILE"
            exit 1
          fi
        else
          log "ERROR: MQTT environment file not found: $MQTT_ENV_FILE"
          exit 1
        fi

        # Log MQTT connection attempt
        log "Attempting to connect to MQTT broker at $MQTT_HOST"

        # Main loop: Subscribe to MQTT topic and process incoming messages
        ${pkgs.mosquitto}/bin/mosquitto_sub -v -h "$MQTT_HOST" -u "$MQTT_USER" -P "$MQTT_PASS" -t 'home/miniserver24/kiosk-vlc-volume' 2>&1 | while read -r topic volume; do
          if [[ $topic == "home/miniserver24/kiosk-vlc-volume" ]]; then
            log "Received message with topic: $topic"
            log "Received message with volume $volume"

            # Validate volume range (0-512)
            if [[ "$volume" =~ ^[0-9]+$ ]] && (( volume >= 0 && volume <= 512 )); then
              log "Valid volume received: $volume"

              # Get Tapo camera password (used for VLC authentication)
              if [ -f "$TAPO_ENV_FILE" ]; then
                tapo_password=$(${pkgs.gnused}/bin/sed -n "s/TAPO_C210_PASSWORD=//p" "$TAPO_ENV_FILE")
                log "Tapo password retrieved successfully."
              else
                log "ERROR: Tapo environment file not found: $TAPO_ENV_FILE"
                continue
              fi

              # Send volume command to VLC via telnet
              log "Attempting to set VLC volume to $volume"
              if echo -e "$tapo_password\nvolume $volume\nquit\n" | ${pkgs.netcat}/bin/nc -w 5 localhost 4212; then
                log "Successfully set VLC volume to $volume"
              else
                log "ERROR: Failed to set VLC volume. Is VLC running and listening on port 4212?"
              fi
            else
              log "ERROR: Invalid volume received: $volume. Must be between 0 and 512."
            fi
          else
            log "DEBUG: Unexpected topic: $topic"
          fi
        done

        # Log unexpected exit
        log "ERROR: mosquitto_sub loop exited unexpectedly. Service will restart."
      '';
      Restart = "always";
      RestartSec = "5s";
      User = "kiosk";
    };
  };

  hokage = {
    hostName = "miniserver24";
    zfs.hostId = "dabfdb01";
    audio.enable = true;
    serverMba.enable = true;
  };
}
