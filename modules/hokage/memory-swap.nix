{
  config,
  lib,
  ...
}:
let
  cfg = config.hokage.memory-swap;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.hokage.memory-swap = {
    enable = mkEnableOption "memory swap tuning" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    zramSwap.enable = true;
  };
}
