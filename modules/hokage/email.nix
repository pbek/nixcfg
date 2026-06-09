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
  isCaliban = config.networking.hostName == "caliban";

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
    himalaya.enable = lib.mkEnableOption "Himalaya mail client" // {
      default = cfg.enable;
    };
    neomutt.enable = lib.mkEnableOption "NeoMutt mail client";
    aerc.enable = lib.mkEnableOption "aerc mail client" // {
      default = cfg.enable;
    };
  };

  config = lib.mkIf enabled {
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      home.packages = lib.optionals cfg.aerc.enable [
        pkgs.bat
      ];

      programs.himalaya.enable = cfg.himalaya.enable;
      programs.neomutt.enable = cfg.neomutt.enable;
      programs.aerc = lib.mkIf cfg.aerc.enable {
        enable = true;
        extraConfig = {
          general.unsafe-accounts-conf = true;
          viewer = {
            pager = "less -Rc";
            alternatives = "text/plain,text/html";
            always-show-mime = true;
          };
          filters = ''
            text/plain = wrap -w 100 | colorize
            text/html = html | colorize
            text/* = if [ -n "$AERC_FILENAME" ]; then ${pkgs.bat}/bin/bat -fP --file-name="$AERC_FILENAME" --style=plain; else ${pkgs.bat}/bin/bat -fP --style=plain; fi
            .headers = colorize
          '';
        };
        extraBinds = ''
          # Hokage account shortcuts.
          <C-j> = :next-tab<Enter>
          <C-k> = :prev-tab<Enter>

          ${builtins.readFile "${pkgs.aerc}/share/aerc/binds.conf"}

          [messages]
          d = :move Trash<Enter>
          <C-j> = :next-tab<Enter>
          <C-k> = :prev-tab<Enter>

          [messages:account=tugraz]
          d = :move "Deleted Items"<Enter>

          [view]
          d = :move Trash<Enter>

          [view:account=tugraz]
          d = :move "Deleted Items"<Enter>
        '';
      };

      accounts.email.accounts = {
        private = {
          primary = !isCaliban;
          address = "patrizio@bekerle.com";
          realName = "Patrizio Bekerle";
          userName = "patrizio@bekerle.com";
          passwordCommand = passwordCommand "patrizio@bekerle.com";
          folders.inbox = "INBOX";
          folders.trash = "Trash";

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

          himalaya.enable = cfg.himalaya.enable;
          neomutt.enable = cfg.neomutt.enable;
          aerc.enable = cfg.aerc.enable;
        };

        tugraz = {
          primary = isCaliban;
          address = "patrizio.bekerle@tugraz.at";
          realName = "Patrizio Bekerle";
          userName = "pbeke";
          passwordCommand = passwordCommand "patrizio.bekerle@tugraz.at";
          folders.inbox = "INBOX";
          folders.sent = "Sent Items";
          folders.trash = "Deleted Items";

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

          himalaya.enable = cfg.himalaya.enable;
          neomutt.enable = cfg.neomutt.enable;
          aerc.enable = cfg.aerc.enable;
        };
      };
    });
  };
}
