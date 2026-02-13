{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.copilot-api;

  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
in
{
  options.hokage.programs.copilot-api = {
    enable =
      mkEnableOption "Copilot API - Turn GitHub Copilot into OpenAI/Anthropic API compatible server"
      // {
        default = false;
      };

    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ../../../pkgs/copilot-api/package.nix { };
      description = "The copilot-api package to use";
    };

    port = mkOption {
      type = types.port;
      default = 4141;
      description = "Port to listen on";
    };

    verbose = mkOption {
      type = types.bool;
      default = false;
      description = "Enable verbose logging";
    };

    accountType = mkOption {
      type = types.enum [
        "individual"
        "business"
        "enterprise"
      ];
      default = "individual";
      description = "Account type to use";
    };

    manual = mkOption {
      type = types.bool;
      default = false;
      description = "Enable manual request approval";
    };

    rateLimit = mkOption {
      type = types.nullOr types.ints.positive;
      default = null;
      description = "Rate limit in seconds between requests";
    };

    wait = mkOption {
      type = types.bool;
      default = false;
      description = "Wait instead of error when rate limit is hit";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open firewall port for copilot-api";
    };
  };

  config = lib.mkIf cfg.enable {
    # Install the package system-wide
    environment.systemPackages = [ cfg.package ];

    # Open firewall if requested
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    # Create systemd user service for copilot-api
    systemd.user.services.copilot-api = {
      description = "Copilot API - OpenAI/Anthropic API compatible GitHub Copilot server";
      documentation = [ "https://github.com/ericc-ch/copilot-api" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.concatStringsSep " " (
          [
            (lib.getExe cfg.package)
            "start"
          ]
          ++ [ "--port=${toString cfg.port}" ]
          ++ lib.optional cfg.verbose "--verbose"
          ++ [ "--account-type=${cfg.accountType}" ]
          ++ lib.optional cfg.manual "--manual"
          ++ lib.optional (cfg.rateLimit != null) "--rate-limit=${toString cfg.rateLimit}"
          ++ lib.optional cfg.wait "--wait"
        );
        Restart = "on-failure";
        RestartSec = 5;
      };

      wantedBy = [ "default.target" ];
    };

    # Add fish shell alias for convenience
    programs.fish.shellAliases = {
      "copilot-api" = lib.getExe cfg.package;
    };
  };
}
