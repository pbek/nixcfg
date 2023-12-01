{ config, pkgs, inputs, ... }:

{
  # Set some fish config
  programs.fish = {
    enable = true;
    shellAliases = {
      n18 = "nix-shell /home/omega/.shells/node18.nix --run fish";
      p8 = "nix-shell /home/omega/.shells/php8.nix --run fish";
      qtc = "nix-shell /home/omega/.shells/qt5.nix --run qtcreator";
      qtc6 = "nix-shell /home/omega/.shells/qt6.nix --run qtcreator";
      cl = "nix-shell /home/omega/.shells/qt5.nix --run clion";
      cl6 = "nix-shell /home/omega/.shells/qt6.nix --run clion";
      qmake5-path = "nix-shell /home/omega/.shells/qt5.nix --run \"whereis qmake\"";
      qmake6-path = "nix-shell /home/omega/.shells/qt6.nix --run \"whereis qmake\"";
      nsf = "nix-shell --run fish";
      gitc = "git commit";
      gitps = "git push";
      gitpl = "git pull --rec";
      gita = "git add -A";
      gits = "git status";
      gitd = "git diff";
      gitl = "git log";
      vim = "nvim";
      qce = "qc exec --command";
      qcel = "qc exec --command --last";
      qcs = "qc search";
      qcsw = "qc switch";
      ll = "eza -l";
      pia-up = "~/Scripts/pia.sh";
      pia-down = "wg-quick down pia";
      pwdc = "pwd | xclip -sel clip";
      fwup = "fwupdmgr get-updates";
    };
    shellAbbrs = {
      killall = "pkill";
    };
  };

  programs.bash.shellAliases = config.programs.fish.shellAliases;

  # Define a user account. Don't forget to set a password with ?passwd?.
  users.users.omega = {
    isNormalUser = true;
    description = "Patrizio Bekerle";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
    # Yubikey public key
    openssh.authorizedKeys.keys = ["sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@i7work"];
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
