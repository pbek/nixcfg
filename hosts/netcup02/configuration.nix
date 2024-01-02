# netcup02 Netcup server
{ modulesPath, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/mixins/server-common.nix
#      (modulesPath + "/installer/scan/not-detected.nix")
#      (modulesPath + "/profiles/qemu-guest.nix")
      ./disk-config.zfs.nix
    ];

  # Bootloader.
#  boot.loader.grub.device = "/dev/vda";
#  boot.loader.grub.useOSProber = true;
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
    hostId = "dafdad02";  # needed for ZFS
    hostName = "netcup02";
    networkmanager.enable = true;

#    interfaces.eth0 = {
#      ipv4.addresses = [{
#  #      address = "192.168.1.100";
#  #      prefixLength = 24;
#        address = "194.59.206.202";
#        prefixLength = 22;
#      }];
#      ipv6.addresses = [
#        {
#          address = "2a03:4000:34:98:2467:b3ff:feb0:b4e3";
#          prefixLength = 64;
#        }
#        {
#          address = "fe80::2467:b3ff:feb0:b4e3";
#          prefixLength = 64;
#        }
#      ];
#    };
#
##    defaultGateway = "192.168.1.1";
#    defaultGateway = "194.59.204.1";
#
##    nameservers = [ "1.1.1.1" "8.8.8.8" ];
#    nameservers = [ "46.38.225.230" "46.38.252.230" "2a03:4000:0:1::e1e6" ];

    # ssh is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [ 25 ]; # SMTP
    };
  };

  environment.systemPackages = with pkgs; [
  ];
}
