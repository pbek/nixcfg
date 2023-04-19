{ lib, ... }:
{
  # https://mynixos.com/options/services.openssh
  services.openssh = {
    enable = true;
    openFirewall = lib.mkForce true;

    settings.PasswordAuthentication = false;
    settings.X11Forwarding = true;
    settings.PermitRootLogin = lib.mkForce "no";

    extraConfig = ''StreamLocalBindUnlink yes'';

    # Deprecated in unstable
#    passwordAuthentication = false;
#    forwardX11 = true;
#    permitRootLogin = lib.mkForce "no";
  };
}
