{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hokage.uutils;
in
{
  options.hokage.uutils = {
    enable = lib.mkEnableOption "uutils service";
  };

  config = lib.mkIf cfg.enable {
    # TODO: Doesn't seem to work yet, all the coreutils commands are still using GNU coreutils
    environment.systemPackages = with pkgs; [
      # Rust replacements for coreutils, findutils, and diffutils
      # https://discourse.nixos.org/t/how-to-use-uutils-coreutils-instead-of-the-builtin-coreutils/8904/24
      (lib.hiPrio uutils-coreutils-noprefix)
      (lib.hiPrio uutils-findutils)
      (lib.hiPrio uutils-diffutils)
    ];
  };
}
