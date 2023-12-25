{ config, pkgs, ... }:

{
  home-manager.users.omega = {
    services.espanso = {
      enable = true;
#      matches = [
#        {
#          trigger = ":sg";
#          replace = "Sehr geehrter ";
#        }
#      ];
      matches = {
        base = {
          matches = [
            {
              trigger = ":sg";
              replace = "Sehr geehrter ";
            }
            {
              trigger = ":lg";
              replace = "Liebe Grüße Patrizio";
            }
            {
              trigger = ":glg";
              replace = "Ganz liebe Grüße Patrizio";
            }
            {
              trigger = ":mfg";
              replace = "Mit freundlichen Grüßen\nPatrizio Bekerle\n";
            }
            {
              trigger = ":date";
              replace = "{{mydate}}";
              vars =  [
                {
                  name = "mydate";
                  type = "date";
                  params = {
                    format = "%d.%m.%Y";
                  };
                }
              ];
            }
          ];
        };
      };
    };
  };
}
