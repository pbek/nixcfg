{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.platformio;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.programs.platformio = {
    enable = mkEnableOption "Enable PlatformIO support";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      platformio
      avrdude
    ];

    services.udev.packages = with pkgs; [
      platformio-core
      openocd
    ];
  };
}
