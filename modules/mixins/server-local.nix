{ config, inputs, ... }:
{
  imports = [
    ./server-common.nix
  ];

  # https://mynixos.com/options/services.openssh
  services.openssh = {
    listenAddresses = [ { addr = "0.0.0.0"; port = 22; } ];
  };

  # Firewall
  # https://nixos.wiki/wiki/Firewall
  networking.firewall = {
    allowedTCPPorts = [ 22 ]; # SSH
  };
}
