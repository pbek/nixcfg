{ lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
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

  # https://rycee.gitlab.io/home-manager/options.html
  home-manager.users.omega = {
    home.file.".ssh/id_ecdsa_sk.pub".text = ''
      sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== yubikey@secret
    '';
  };

  age.secrets = {
    id_ecdsa_sk = {
      file = ../../secrets/id_ecdsa_sk.age;
      path = "/home/omega/.ssh/id_ecdsa_sk";
      owner = "omega";
      group = "users";
      mode = "600";
    };
  };
}
