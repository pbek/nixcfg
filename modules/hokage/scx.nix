{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.scx;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.hokage.scx = {
    enable = mkEnableOption "sched-ext userspace scheduler";

    package = mkOption {
      type = types.package;
      default = pkgs.scx.full;
      description = "SCX package to install and use for the scheduler service.";
    };

    scheduler = mkOption {
      type = types.enum [
        "scx_beerland"
        "scx_bpfland"
        "scx_chaos"
        "scx_cosmos"
        "scx_central"
        "scx_flash"
        "scx_flatcg"
        "scx_lavd"
        "scx_layered"
        "scx_mitosis"
        "scx_nest"
        "scx_p2dq"
        "scx_pair"
        "scx_prev"
        "scx_qmap"
        "scx_rlfifo"
        "scx_rustland"
        "scx_rusty"
        "scx_sdt"
        "scx_simple"
        "scx_tickless"
        "scx_userland"
        "scx_wd40"
      ];
      default = "scx_rustland";
      description = "SCX scheduler to run via services.scx.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra arguments passed to the selected SCX scheduler.";
    };
  };

  config = mkIf cfg.enable {
    services.scx = {
      enable = true;
      inherit (cfg) package scheduler extraArgs;
    };
  };
}
