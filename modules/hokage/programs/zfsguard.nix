{
  config,
  lib,
  inputs,
  system,
  ...
}:

let
  inherit (config) hokage;
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.hokage.programs.zfsguard;
in
{
  options.hokage.programs.zfsguard = {
    enable = mkEnableOption "ZFSGuard health monitoring service" // {
      default = hokage.role == "desktop" || hokage.role == "ally";
    };

    intervalMinutes = mkOption {
      type = types.int;
      default = 60;
      description = "Interval in minutes between ZFS/SMART health checks.";
    };

    checkZfs = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to check ZFS pool health.";
    };

    checkSmart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to check SMART disk health.";
    };

    smartDevices = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of devices to check for SMART health. Empty means auto-detect.";
      example = [
        "/dev/sda"
        "/dev/nvme0"
      ];
    };

    desktopNotifications = mkOption {
      type = types.bool;
      default = true;
      description = "Enable local Linux desktop notifications via notify-send.";
    };

    shoutrrrUrls = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Shoutrrr notification URLs for remote alerting. Examples:
        - "discord://token@id"
        - "telegram://token@telegram?channels=channel"
        - "gotify://host/token"
        - "ntfy://ntfy.sh/topic"
      '';
    };
  };

  config = mkIf cfg.enable {
    services.zfsguard = {
      enable = true;
      package = inputs.zfsguard.packages.${system}.default;
      settings = {
        monitor = {
          interval_minutes = cfg.intervalMinutes;
          check_zfs = cfg.checkZfs;
          check_smart = cfg.checkSmart;
          smart_devices = cfg.smartDevices;
        };
        notify = {
          shoutrrr_urls = cfg.shoutrrrUrls;
          desktop = cfg.desktopNotifications;
        };
      };
    };
  };
}
