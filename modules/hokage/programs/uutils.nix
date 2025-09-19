{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config) hokage;
  cfg = hokage.programs.uutils;
in
{
  options.hokage.programs.uutils = {
    enable =
      lib.mkEnableOption "Turn on uutils replacements for GNU utils, changes seems to need reboot"
      // {
        default = hokage.role == "desktop" || hokage.role == "ally";
      };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Rust replacements for coreutils, findutils, and diffutils
      # https://discourse.nixos.org/t/how-to-use-uutils-coreutils-instead-of-the-builtin-coreutils/8904/24
      (lib.hiPrio uutils-coreutils-noprefix)
      (lib.hiPrio uutils-findutils)
      (lib.hiPrio uutils-diffutils)
    ];
  };
}
