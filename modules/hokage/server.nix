{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userNameLong;
  inherit (hokage) userEmail;
in
{
  config = lib.mkIf (hokage.role == "server-home" || hokage.role == "server-remote") {
    # Also make snapshots of the docker dataset (not only home)
    services.sanoid = {
      datasets = {
        "zroot/docker" = {
          useTemplate = [ "hourly" ];
        };
      };
    };

    # https://mynixos.com/options/services.openssh
    services.openssh = {
      enable = true;
      openFirewall = lib.mkForce true;
      settings.PasswordAuthentication = false;
      settings.PermitRootLogin = lib.mkForce "no";
    };

    # Docker
    # https://wiki.nixos.org/wiki/Docker
    virtualisation.docker.enable = true;

    # https://wiki.nixos.org/wiki/Fail2ban
    services.fail2ban.enable = lib.mkDefault true;

    # Firewall
    # https://wiki.nixos.org/wiki/Firewall
    networking.firewall = {
      enable = lib.mkDefault true;
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
    home-manager.users = lib.genAttrs hokage.usersWithRoot (_userName: {
      programs.git = {
        enable = true;
        # use "git diff --no-ext-diff" for creating patches!
        difftastic.enable = true;
        userName = lib.mkDefault userNameLong;
        userEmail = lib.mkDefault userEmail;
        ignores = [
          ".idea"
          ".direnv"
        ];
      };
    });

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      python3 # for Ansible
      lazydocker
    ];

    programs.fish.shellAliases = {
      lzd = "lazydocker";
    };

    hokage = {
      useSecrets = lib.mkDefault false;
      zfs = {
        enable = true;
        encrypted = lib.mkDefault false;
      };
      useGraphicalSystem = false;
    };
  };
}
