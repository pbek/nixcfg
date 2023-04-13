{ lib, ... }:
{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    forwardX11 = true;
    openFirewall = lib.mkForce true;
    permitRootLogin = lib.mkForce "no";
  };
}
