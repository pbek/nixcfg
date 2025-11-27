# Thinkstation Andrea

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  ...
}:
{
  imports = [
    ./disk-config.zfs.nix
  ];

  environment.systemPackages = with pkgs; [
    thunderbird
    spotify
    evolution
    evolution-ews
  ];

  hokage = {
    hostName = "dp04";
    userLogin = "dp";
    # userNameLong = "dp";
    # userNameShort = "dp";
    # userEmail = "dp@dp";

    # Temporary "owner" of this machine
    userNameLong = "Andrea Ortner";
    userNameShort = "Andrea";
    userEmail = "andrea.ortner@tugraz.at";

    tugraz.enableExternal = true;
    waylandSupport = false;

    zfs = {
      enable = true;
      hostId = "dccada04";
      poolName = "calroot";
    };

    nvidia = {
      enable = true;
      packageType = "beta";
      # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
      # NVIDIA Quadro P620 didn't work properly with open = true
      open = false;
    };
  };
}
