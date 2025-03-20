{
  lib,
  config,
  ...
}:
let
  inherit (config.services.hokage) userLogin;
  inherit (config.services.hokage) useSecrets;
  inherit (config.services.hokage) useSharedKey;
in
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
  home-manager.users.${userLogin} = lib.mkIf useSharedKey {
    home.file.".ssh/id_ecdsa_sk.pub".text = ''
      sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== yubikey@secret
    '';
  };

  # Add Yubikey private ssh key
  age.secrets =
    if useSecrets then
      {
        id_ecdsa_sk = {
          file = ../../secrets/id_ecdsa_sk.age;
          path = "/home/${userLogin}/.ssh/id_ecdsa_sk";
          owner = userLogin;
          group = "users";
          mode = "600";
        };
      }
    else
      { };
}
