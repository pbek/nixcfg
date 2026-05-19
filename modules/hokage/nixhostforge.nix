{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.hokage.services.nixhostforge;
in
{
  imports = [
    inputs.nixhostforge.nixosModules.default
  ];

  options.hokage.services.nixhostforge = {
    enable = lib.mkEnableOption "NixHostForge host configuration prebuilder";

    repository = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/pbek/nixcfg.git";
      description = "Git repository URL containing the Nix flake to check.";
    };

    branch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "Git branch to watch.";
    };

    interval = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "15m";
      description = "Polling interval as a Go duration string. Leave null to configure it in the web UI.";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address for the web interface to listen on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9637;
      description = "Port for the web interface.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the web interface port in the firewall.";
    };

    concurrency = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      example = 1;
      description = "Maximum number of concurrent host builds. Leave null to configure it in the web UI.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nixhostforge = {
      inherit (cfg)
        repository
        branch
        interval
        listenAddress
        port
        openFirewall
        concurrency
        ;

      enable = true;
    };
  };
}
