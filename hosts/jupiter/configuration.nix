# Asus Laptop

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/hokage
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-fd774d6e-6a78-4d0b-a06e-fb759e2eb6b2".device =
    "/dev/disk/by-uuid/fd774d6e-6a78-4d0b-a06e-fb759e2eb6b2";
  boot.initrd.luks.devices."luks-fd774d6e-6a78-4d0b-a06e-fb759e2eb6b2".keyFile =
    "/crypto_keyfile.bin";

  hardware.nvidia.prime = {
    sync.enable = true;

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:3:0:0";

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
  };

  hokage = {
    hostName = "jupiter";
    cache.sources = [ "home" ];
    lowBandwidth = true;

    nvidia = {
      enable = true;
      modesetting.enable = true;
      # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
      open = false;
    };
  };
}
