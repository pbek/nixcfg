{ config, pkgs, inputs, username, ... }:

{
  # Set some fish config
  programs.fish = {
    shellAliases = {
      n18 = "nix-shell /home/${username}/.shells/node18.nix --run fish";
      p8 = "nix-shell /home/${username}/.shells/php8.nix --run fish";
      qtc = "nix-shell /home/${username}/.shells/qt5.nix --run qtcreator";
      qtc6 = "nix-shell /home/${username}/.shells/qt6.nix --run qtcreator";
      cl = "nix-shell /home/${username}/.shells/qt5.nix --run clion";
      cl6 = "nix-shell /home/${username}/.shells/qt6.nix --run clion";
      qmake5-path = "nix-shell /home/${username}/.shells/qt5.nix --run \"whereis qmake\"";
      qmake6-path = "nix-shell /home/${username}/.shells/qt6.nix --run \"whereis qmake\"";
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

  # Add nixpkgs-review environment
  age.secrets = {
    nixpkgs-review = {
      file = ../../secrets/nixpkgs-review.age;
      path = "/home/${username}/.secrets/nixpkgs-review.env";
      owner = username;
      group = "users";
      mode = "600";
    };

    pia-user = {
      file = ../../secrets/pia-user.age;
      path = "/home/${username}/.secrets/pia-user";
      owner = username;
      group = "users";
      mode = "600";
    };

    pia-pass = {
      file = ../../secrets/pia-pass.age;
      path = "/home/${username}/.secrets/pia-pass";
      owner = username;
      group = "users";
      mode = "600";
    };

    github-token = {
      file = ../../secrets/github-token.age;
      path = "/home/${username}/.secrets/github-token";
      owner = username;
      group = "users";
      mode = "600";
    };

    neosay = {
      file = ../../secrets/neosay.age;
      path = "/home/${username}/.config/neosay/config.json";
      owner = username;
      group = "users";
      mode = "600";
    };

    atuin = {
      file = ../../secrets/atuin.age;
      path = "/home/${username}/.secrets/atuin-key";
      owner = username;
      group = "users";
      mode = "600";
    };

    qc-config = {
      file = ../../secrets/qc-config.age;
      path = "/home/${username}/.config/qc/config.toml";
      owner = username;
      group = "users";
      mode = "600";
    };
  };
}
