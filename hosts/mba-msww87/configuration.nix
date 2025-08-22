# mba-msww87 server
{
  config,
  pkgs,
  ...
}:
let
  inherit (config.hokage) userLogin;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hokage
    ./disk-config.zfs.nix
  ];

  networking = {
    # SSH is already enabled by the server-common mixin
    firewall = {
      allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
        8883 # MQTT
      ];
      allowedUDPPorts = [
        443 # HTTPS
      ];
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  environment.variables.EDITOR = "nano";
  programs.fish.interactiveShellInit = "export EDITOR=nano";

  users.users.${userLogin} = {
    openssh.authorizedKeys.keys = [
      # Markus public key
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGIQIkx1H1iVXWYKnHkxQsS7tGsZq3SoHxlVccd+kroMC/DhC4MWwVnJInWwDpo/bz7LiLuh+1Bmq04PswD78EiHVVQ+O7Ckk32heWrywD2vufihukhKRTy5zl6uodb5+oa8PBholTnw09d3M0gbsVKfLEi4NDlgPJiiQsIU00ct/y42nI0s1wXhYn/Oudfqh0yRfGvv2DZowN+XGkxQQ5LSCBYYabBK/W9imvqrxizttw02h2/u3knXcsUpOEhcWJYHHn/0mw33tl6a093bT2IfFPFb3LE2KxUjVqwIYz8jou8cb0F/1+QJVKtqOVLMvDBMqyXAhCkvwtEz13KEyt"
    ];
  };

  hokage = {
    hostName = "mba-msww87";
    role = "server-home";
    userLogin = "mba";
    userNameLong = "Markus Barta";
    userNameShort = "Markus";
    userEmail = "markus@barta.com";
    useInternalInfrastructure = false;
    useSecrets = false;
    zfs.hostId = "cdbc4e20";
  };
}
