# PC Garage

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  ...
}:
{
  imports = [ ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://wiki.nixos.org/wiki/steam
  #  programs.steam = {
  #    enable = true;
  #    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #  };

  hokage = {
    hostName = "pluto";
    lowBandwidth = true;
    useGhosttyGtkFix = false;
    cache.sources = [ "home" ];
  };
}
