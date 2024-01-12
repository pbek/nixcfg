{ config, pkgs, inputs, ... }:

{
  # Set some fish config
  programs.fish = {
    shellAliases = {
      n18 = "nix-shell /home/omega/.shells/node18.nix --run fish";
      p8 = "nix-shell /home/omega/.shells/php8.nix --run fish";
      qtc = "nix-shell /home/omega/.shells/qt5.nix --run qtcreator";
      qtc6 = "nix-shell /home/omega/.shells/qt6.nix --run qtcreator";
      cl = "nix-shell /home/omega/.shells/qt5.nix --run clion";
      cl6 = "nix-shell /home/omega/.shells/qt6.nix --run clion";
      qmake5-path = "nix-shell /home/omega/.shells/qt5.nix --run \"whereis qmake\"";
      qmake6-path = "nix-shell /home/omega/.shells/qt6.nix --run \"whereis qmake\"";
      qce = "qc exec --command";
      qcel = "qc exec --command --last";
      qcs = "qc search";
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
      path = "/home/omega/.secrets/nixpkgs-review.env";
      owner = "omega";
      group = "users";
      mode = "600";
    };

    pia-user = {
      file = ../../secrets/pia-user.age;
      path = "/home/omega/.secrets/pia-user";
      owner = "omega";
      group = "users";
      mode = "600";
    };

    pia-pass = {
      file = ../../secrets/pia-pass.age;
      path = "/home/omega/.secrets/pia-pass";
      owner = "omega";
      group = "users";
      mode = "600";
    };

    github-token = {
      file = ../../secrets/github-token.age;
      path = "/home/omega/.secrets/github-token";
      owner = "omega";
      group = "users";
      mode = "600";
    };
  };
}
