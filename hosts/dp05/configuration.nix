# TU Thinkbook P52 Tobias

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.zfs.nix
    ../../modules/hokage
  ];

  # Search on https://search.nixos.org/packages?channel=unstable
  environment.systemPackages = with pkgs; [
    thunderbird
    digikam
    gimp
  ];

  hokage = {
    hostName = "dp05";
    userLogin = "tgros";
    userNameLong = "Tobias Groß-Vogt";
    userNameShort = "Tobias";
    userEmail = "tobias.gross-vogt@tugraz.at";
    tugraz.enableExternal = true;

    zfs = {
      enable = true;
      hostId = "dccada05";
      encrypted = true;
    };

    nvidia = {
      enable = true;
      packageType = "beta";
      # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
      open = false;
    };
  };
}
