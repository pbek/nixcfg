# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b0e9faee-a598-4b00-b4b3-04f29082b683";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-0c61fa7d-13b2-4116-907c-9dfe6b1ac7b5".device =
    "/dev/disk/by-uuid/0c61fa7d-13b2-4116-907c-9dfe6b1ac7b5";

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/1584-E3A7";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/525b3ba2-aebd-48eb-8026-7d247a0335bc"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
