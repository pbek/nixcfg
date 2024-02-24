{ config, inputs, ... }:
{
  imports = [
    ./server-common.nix
  ];

  # Firewall
  # https://nixos.wiki/wiki/Firewall
  networking.firewall = {
    allowedTCPPorts = [ 22 ]; # SSH
  };
}
