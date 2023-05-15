{ config, pkgs, inputs, ... }:

{
  # Set some fish config
  programs.fish = {
    enable = true;
    shellAliases = {
      n18 = "nix-shell /etc/nixos/shells/node18.nix --run fish";
      p8 = "nix-shell /etc/nixos/shells/php8.nix --run fish";
      qtc = "nix-shell /etc/nixos/shells/qt5.nix --run qtcreator";
      cl = "nix-shell /etc/nixos/shells/qt5.nix --run clion";
      nsf = "nix-shell --run fish";
      gitc = "git commit";
      gitp = "git push";
      gita = "git add -A";
      gits = "git status";
      gitd = "git diff";
      gitl = "git log";
      vim = "nvim";
      qce = "qc exec";
      qcs = "qc search";
      ll = "ls -hal";
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
}
