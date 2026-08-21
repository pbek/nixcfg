{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.services.voxtype;
in
{
  options.hokage.services.voxtype = {
    enable = lib.mkEnableOption "Voxtype speech-to-text daemon";
    gpuSupport = lib.mkEnableOption "Vulkan GPU acceleration for Voxtype";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      services.voxtype = {
        enable = true;
        package = if cfg.gpuSupport then pkgs.voxtype-vulkan else pkgs.voxtype;
        wayland.display = lib.mkIf hokage.waylandSupport "wayland-0";
        loadModels = [ "base" ];
        settings = {
          hotkey = {
            enabled = true;
            key = "SCROLLLOCK";
            mode = "push_to_talk";
          };
          whisper = {
            model = "base";
            language = "auto";
          };
          output.notification = {
            on_recording_start = true;
            on_recording_stop = true;
            on_transcription = true;
          };
        };
      };
    });
  };
}
