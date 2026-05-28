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
    services.pipewire.jack.enable = true;

    environment.systemPackages = with pkgs; [
      sysex-controls # Configure Akai, Arturia, Korg MIDI devices via SysEx
      surge-xt # Synthesizer
      jalv-qt # LV2 plugin host with UI support
      pipewire.jack # PipeWire JACK wrapper such as pw-jack
      jack-example-tools # JACK tools such as jack_lsp and jack_connect
      lmms # Digital audio workstation with MIDI support
      carla # Audio plugin host with MIDI support
      qpwgraph # PipeWire/JACK patchbay for audio and MIDI routing
    ];
  };
}
