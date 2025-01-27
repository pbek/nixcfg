{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  userLogin = config.services.hokage.userLogin;
  useSecrets = config.services.hokage.useSecrets;
in
{
  # Set some fish config
  programs.fish = {
    shellAliases = {
      n18 = "nix-shell /home/${userLogin}/.shells/node18.nix --run fish";
      p8 = "nix-shell /home/${userLogin}/.shells/php8.nix --run fish";
      qtc = "nix-shell /home/${userLogin}/.shells/qt5.nix --run qtcreator";
      qtc6 = "nix-shell /home/${userLogin}/.shells/qt6.nix --run qtcreator";
      cl = "nix-shell /home/${userLogin}/.shells/qt5.nix --run clion";
      cl6 = "nix-shell /home/${userLogin}/.shells/qt6.nix --run clion";
      qmake5-path = "nix-shell /home/${userLogin}/.shells/qt5.nix --run \"whereis qmake\"";
      qmake6-path = "nix-shell /home/${userLogin}/.shells/qt6.nix --run \"whereis qmake\"";
      qce = "qc exec --command --color --atuin";
      qcel = "qc exec --command --color --atuin --last";
      qcs = "qc search --color";
      qcsw = "qc switch";
      pia-up = "~/Scripts/pia.sh";
      pia-down = "wg-quick down pia";
      pwdc = "pwd | xclip -sel clip";
      fwup = "fwupdmgr get-updates";
    };
  };

  age.secrets =
    if useSecrets then
      {
        # Add nixpkgs-review environment
        nixpkgs-review = {
          file = ../../secrets/nixpkgs-review.age;
          path = "/home/${userLogin}/.secrets/nixpkgs-review.env";
          owner = userLogin;
          group = "users";
          mode = "600";
        };

        pia-user = {
          file = ../../secrets/pia-user.age;
          path = "/home/${userLogin}/.secrets/pia-user";
          owner = userLogin;
          group = "users";
          mode = "600";
        };

        pia-pass = {
          file = ../../secrets/pia-pass.age;
          path = "/home/${userLogin}/.secrets/pia-pass";
          owner = userLogin;
          group = "users";
          mode = "600";
        };

        github-token = {
          file = ../../secrets/github-token.age;
          path = "/home/${userLogin}/.secrets/github-token";
          owner = userLogin;
          group = "users";
          mode = "600";
        };

        neosay = {
          file = ../../secrets/neosay.age;
          path = "/home/${userLogin}/.config/neosay/config.json";
          owner = userLogin;
          group = "users";
          mode = "600";
        };

        atuin = {
          file = ../../secrets/atuin.age;
          path = "/home/${userLogin}/.secrets/atuin-key";
          owner = userLogin;
          group = "users";
          mode = "600";
        };

        qc-config = {
          file = ../../secrets/qc-config.age;
          path = "/home/${userLogin}/.config/qc/config.toml";
          owner = userLogin;
          group = "users";
          mode = "600";
        };
      }
    else
      { };
}
