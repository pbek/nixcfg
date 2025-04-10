# moobox01 Netcup server
{
  modulesPath,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/mixins/server-remote.nix
    ./disk-config.zfs.nix
  ];

  networking = {
    hostName = "moobox01";
    networkmanager.enable = true;

    # SSH is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
      ];
      allowedUDPPorts = [
        443 # HTTPS
      ];
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  services.hokage = {
    userLogin = "cow";
    userNameLong = "cow";
    userNameShort = "cow";
    userEmail = "cow@cow";
    useSecrets = false;
    useInternalInfrastructure = false;
  };

  services.hokage = {
    zfs.hostId = "dacdad01";
  };
}
