{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.hokage.synth;

  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.hokage.synth = {
    enable = mkEnableOption "synthesizer and MIDI device tooling";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sysex-controls # Configure Akai, Arturia, Korg MIDI devices via SysEx
      surge-xt # Synthesizer
    ];
  };
}
