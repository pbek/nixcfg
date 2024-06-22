# miniserver24 server for Markus
{ modulesPath, config, pkgs, username, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/mixins/server-local.nix
      ../../modules/mixins/remote-store-cache.nix
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

  # No password needed for sudo for wheel group
  security.sudo.wheelNeedsPassword = false;

  users.users.${username} = {
    description = "Markus";
    openssh.authorizedKeys.keys = [
      # Markus public key
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGIQIkx1H1iVXWYKnHkxQsS7tGsZq3SoHxlVccd+kroMC/DhC4MWwVnJInWwDpo/bz7LiLuh+1Bmq04PswD78EiHVVQ+O7Ckk32heWrywD2vufihukhKRTy5zl6uodb5+oa8PBholTnw09d3M0gbsVKfLEi4NDlgPJiiQsIU00ct/y42nI0s1wXhYn/Oudfqh0yRfGvv2DZowN+XGkxQQ5LSCBYYabBK/W9imvqrxizttw02h2/u3knXcsUpOEhcWJYHHn/0mw33tl6a093bT2IfFPFb3LE2KxUjVqwIYz8jou8cb0F/1+QJVKtqOVLMvDBMqyXAhCkvwtEz13KEyt"
    ];
  };

  networking = {
    hostId = "dabfdb01";  # needed for ZFS
    hostName = "miniserver24";
    networkmanager.enable = true;

    nameservers = ["192.168.1.100"];
    defaultGateway = "192.168.1.5";

    interfaces.enp3s0f0 = {
      ipv4.addresses = [{ address = "192.168.1.101"; prefixLength = 24; }];
    };

    # SSH is already enabled by the server-common mixin
    firewall = {
      # Disable the firewall if not needed
#      enable = false;
      allowedTCPPorts = [
        80    # HTTP
        443   # HTTPS
        1880  # Node-RED Web UI
        1883  # MQTT
      ];
      allowedUDPPorts = [
        443 # HTTPS
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

  environment.systemPackages = with pkgs; [
  ];
}
