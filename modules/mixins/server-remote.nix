{ config, inputs, ... }:
{
  imports = [
    ./server-common.nix
  ];

  # https://mynixos.com/options/services.openssh
  services.openssh = {
    listenAddresses = [ { addr = "0.0.0.0"; port = 2222; } ];
  };

  # Firewall
  # https://nixos.wiki/wiki/Firewall
  networking.firewall = {
    allowedTCPPorts = [ 2222 ]; # SSH
  };
}
