# Astra TUG VM

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

  # Enable Tailscale VPN
  # Use `sudo tailscale up --accept-routes` to connect to the VPN
  # services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
  ];

  services.kmscon.enable = false;

  hokage = {
    hostName = "astra";
    termFontSize = 16.0;
    useGhosttyGtkFix = false;
    programs.libvirt.role = "guest";
    cache.sources = [ "caliban" ];
    zfs = {
      enable = true;
      hostId = "4ea35514";
      encrypted = true;
      devNodes = "/dev/disk/by-path";
      useSystemdInitrd = true;
    };
  };
}
