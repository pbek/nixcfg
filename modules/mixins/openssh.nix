{ lib, ... }:
{
  services.openssh = {
    enable = true;
    openFirewall = lib.mkForce true;

    PasswordAuthentication = false;
    X11Forwarding = true;
    PermitRootLogin = lib.mkForce "no";

    # Deprecated in unstable
#    passwordAuthentication = false;
#    forwardX11 = true;
#    permitRootLogin = lib.mkForce "no";
  };
}
