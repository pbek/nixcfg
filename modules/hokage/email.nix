{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.mail;

  enabled = cfg.enable && hokage.role == "desktop" && hokage.useInternalInfrastructure;

  passwordCommand = address: [
    "${pkgs.libsecret}/bin/secret-tool"
    "lookup"
    "email"
    address
  ];
in
{
  options.hokage.mail = {
    enable = lib.mkEnableOption "Himalaya mail accounts" // {
      default = hokage.role == "desktop" && hokage.useInternalInfrastructure;
    };
  };

  config = lib.mkIf enabled {
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      programs.himalaya.enable = true;

      accounts.email.accounts = {
        private = {
          primary = true;
          address = "patrizio@bekerle.com";
          realName = "Patrizio Bekerle";
          userName = "patrizio@bekerle.com";
          passwordCommand = passwordCommand "patrizio@bekerle.com";
          folders.inbox = "INBOX";

          imap = {
            host = "mail.bekerle.com";
            port = 143;
            tls.useStartTls = true;
          };

          smtp = {
            host = "mail.bekerle.com";
            port = 25;
            tls.useStartTls = true;
          };

          himalaya.enable = true;
        };

        tugraz = {
          address = "patrizio.bekerle@tugraz.at";
          realName = "Patrizio Bekerle";
          userName = "pbeke";
          passwordCommand = passwordCommand "patrizio.bekerle@tugraz.at";
          folders.inbox = "INBOX";

          imap = {
            host = "exchange.tugraz.at";
            port = 993;
            tls.enable = true;
          };

          smtp = {
            host = "mailrelay.tugraz.at";
            port = 587;
            tls.useStartTls = true;
          };

          himalaya.enable = true;
        };
      };
    });
  };
}
