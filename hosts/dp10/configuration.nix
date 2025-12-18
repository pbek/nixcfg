# PC Home Shiva

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  ...
}:
{
  imports = [
    ../dp06/shiva.nix
  ];

  users.users.user = {
    openssh.authorizedKeys.keys = [
      # Shiva Laptop public key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIArlTbzSLIYPvhCAIJDDIHt0fWKgjWRxlHMkV9269OKL user@dp06"
    ];
  };

  hokage = {
    hostName = "dp10";
    zfs.hostId = "e8fd4331";
    gaming.enable = true;

    nvidia = {
      enable = true;
      # packageType = "beta";
      # NVIDIA RTX 3070
      # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
      open = true;
    };
  };
}
