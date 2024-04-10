{ lib, username, ... }:
{
  # https://mynixos.com/options/services.openssh
  services.openssh = {
    enable = true;
    openFirewall = lib.mkForce true;

    settings.X11Forwarding = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = lib.mkForce "no";

    # To use with nixos-anywhere you need to use this settings
#    settings.PermitRootLogin = "yes";
#    settings.PasswordAuthentication = true;

    extraConfig = ''StreamLocalBindUnlink yes'';
  };

  # Add Yubikey public ssh key
  # https://rycee.gitlab.io/home-manager/options.html
  home-manager.users.${username} = {
    home.file.".ssh/id_ecdsa_sk.pub".text = ''
      sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== yubikey@secret
    '';
  };

  # Add Yubikey private ssh key
  age.secrets = {
    id_ecdsa_sk = {
      file = ../../secrets/id_ecdsa_sk.age;
      path = "/home/${username}/.ssh/id_ecdsa_sk";
      owner = username;
      group = "users";
      mode = "600";
    };
  };
}
