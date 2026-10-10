{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hokage.programs.openchamber;
  home = config.users.users.${cfg.user}.home;
in
{
  options.hokage.programs.openchamber = {
    enable = lib.mkEnableOption "the OpenChamber web service";

    package = lib.mkPackageOption pkgs "openchamber" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = config.hokage.userLogin;
      defaultText = lib.literalExpression "config.hokage.userLogin";
      description = "Existing user under which OpenChamber runs at boot, without requiring login.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address on which the OpenChamber web interface listens.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Web interface port. The OpenCode backend port is managed automatically.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the web interface port in the firewall.";
    };

    passwordFile = lib.mkOption {
      type = lib.types.str;
      default = config.age.secrets.openchamber-ui-password.path;
      defaultText = lib.literalExpression "config.age.secrets.openchamber-ui-password.path";
      description = "Runtime path to a nonempty file containing the UI password, for example an Agenix secret path. Never use a plaintext Nix store file.";
    };

    passwordSecretFile = lib.mkOption {
      type = lib.types.path;
      default = ../../../secrets/openchamber-ui-password.age;
      description = "Agenix-encrypted file containing the UI password.";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.openchamber-ui-password = {
      file = cfg.passwordSecretFile;
      mode = "600";
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.openchamber = {
      description = "OpenChamber web interface";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      unitConfig.RequiresMountsFor = home;
      restartTriggers = [ cfg.passwordSecretFile ];

      # Include user tools for OpenCode, while retaining systemd's default PATH.
      path = [
        "/etc/profiles/per-user/${cfg.user}"
        "${home}/.nix-profile"
        "/run/current-system/sw"
      ];
      environment = {
        HOME = home;
      }
      // lib.optionalAttrs (config.environment.sessionVariables ? AZURE_RESOURCE_NAME) {
        AZURE_RESOURCE_NAME = config.environment.sessionVariables.AZURE_RESOURCE_NAME;
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        WorkingDirectory = home;
        LoadCredential = "ui-password:${cfg.passwordFile}";
        Restart = "on-failure";
        RestartSec = "5s";
        UMask = "0077";
      };

      script = ''
        export OPENCHAMBER_UI_PASSWORD="$(cat "$CREDENTIALS_DIRECTORY/ui-password")"
        test -n "$OPENCHAMBER_UI_PASSWORD"
        unset OPENCODE_PORT
        exec ${lib.getExe cfg.package} serve --foreground \
          --host ${lib.escapeShellArg cfg.host} --port ${toString cfg.port}
      '';
    };
  };
}
