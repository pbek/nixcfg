# TU Laptop Ruxandra - Lenovo ThinkPad P15 Gen1 (NVIDIA Quadro T1000)

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
  ];

  environment.systemPackages = with pkgs; [
    backintime
    webex
  ];

  hardware.nvidia.prime = {
    sync.enable = true;

    # NVIDIA Quadro T1000
    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
  };

  hokage = {
    hostName = "dp09";
    userLogin = "ruxi";
    userNameLong = "Ruxandra-Ileana Gherman";
    userNameShort = "Ruxandra";
    userEmail = "r.gherman@tugraz.at";
    tugraz.enableExternal = true;

    nvidia = {
      enable = true;
      open = false;
      packageType = "beta";
      modesetting.enable = true;
    };

    zfs = {
      enable = true;
      hostId = "e783460f";
    };
  };
}
