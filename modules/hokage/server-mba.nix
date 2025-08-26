# MBA specific server config
{ config, lib, ... }:
let
  inherit (config) hokage;
  cfg = hokage.serverMba;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.serverMba = {
    enable = mkEnableOption "Enable MBA server configuration";
  };

  config = lib.mkIf cfg.enable {
    # No password needed for sudo for wheel group
    security.sudo.wheelNeedsPassword = false;

    users.users.mba = {
      description = "Markus";
      openssh.authorizedKeys.keys = [
        # Public key of mba
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGIQIkx1H1iVXWYKnHkxQsS7tGsZq3SoHxlVccd+kroMC/DhC4MWwVnJInWwDpo/bz7LiLuh+1Bmq04PswD78EiHVVQ+O7Ckk32heWrywD2vufihukhKRTy5zl6uodb5+oa8PBholTnw09d3M0gbsVKfLEi4NDlgPJiiQsIU00ct/y42nI0s1wXhYn/Oudfqh0yRfGvv2DZowN+XGkxQQ5LSCBYYabBK/W9imvqrxizttw02h2/u3knXcsUpOEhcWJYHHn/0mw33tl6a093bT2IfFPFb3LE2KxUjVqwIYz8jou8cb0F/1+QJVKtqOVLMvDBMqyXAhCkvwtEz13KEyt"
      ];
    };

    # Set mba specific fish configc
    programs.fish = {
      shellAliases = {
        # mc = "EDITOR=nano mc";
      };
      shellAbbrs = {
        # cat = "bat";
      };
      interactiveShellInit = ''
        function sourcefish --description 'Load env vars from a .env file into current Fish session'
          set file "$argv[1]"
          if test -z "$file"
            echo "Usage: sourcefish PATH_TO_ENV_FILE"
            return 1
          end
          if test -f "$file"
            for line in (cat "$file" | grep -v '^[[:space:]]*#' | grep .)
              set key (echo $line | cut -d= -f1)
              set val (echo $line | cut -d= -f2-)
              set -gx $key "$val"
            end
          else
            echo "File not found: $file"
            return 1
          end
        end
        export EDITOR=nano
      '';
    };

    hokage = {
      role = "server-home";
      userLogin = "mba";
      userNameLong = "Markus Barta";
      userNameShort = "Markus";
      userEmail = "markus@barta.com";
      useInternalInfrastructure = false;
      useSecrets = false;
      zfs = {
        enable = true;
      };
    };
  };
}
