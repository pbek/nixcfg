{ config, pkgs, inputs, lib, username, ... }:
{
  imports = [
    ./common.nix
  ];

  # https://mynixos.com/options/services.openssh
  services.openssh = {
    enable = true;
    openFirewall = lib.mkForce true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = lib.mkForce "no";
  };

  # https://nixos.wiki/wiki/Fail2ban
  services.fail2ban.enable = true;

  # Firewall
  # https://nixos.wiki/wiki/Firewall
  networking.firewall = {
    enable = true;
  };

  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };

  # https://rycee.gitlab.io/home-manager/options.html
  home-manager.users.${username} = {
    programs.git = {
      enable = true;
      # use "git diff --no-ext-diff" for creating patches!
      difftastic.enable = true;
      userName  = "Patrizio Bekerle";
      userEmail = "patrizio@bekerle.com";
      ignores = [ ".idea" ".direnv" ];
    };
  };

  # Set empty password initially. Don't forget to set a password with "passwd".
  users.users.${username} = {
    initialHashedPassword = "";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python3 # for Ansible
  ];
}
