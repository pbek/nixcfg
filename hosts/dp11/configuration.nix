# TU Laptop Vici - Lenovo ThinkPad P15 Gen1 (NVIDIA Quadro T1000)

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
    hostName = "dp11";
    userLogin = "vici";
    userNameLong = "Victoria Graf";
    userNameShort = "Victoria";
    userEmail = "victoria.graf@tugraz.at";
    tugraz.enableExternal = true;

    nvidia = {
      enable = true;
      open = false;
      packageType = "latest";
      modesetting.enable = true;
    };

    zfs = {
      enable = true;
      hostId = "e833570d";
    };
  };
}
