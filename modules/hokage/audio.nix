{
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
in
{
  config = lib.mkIf (hokage.role == "desktop" || hokage.role == "ally") {
    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Try turning timer-based scheduling off for pulseaudio to prevent clicking and garbled audio
    # See https://wiki.nixos.org/wiki/PulseAudio#Clicking_and_Garbled_Audio
    # But this resulted in gaps in audio playback for me, so I left it commented out.
    #    services.pulseaudio.configFile = pkgs.runCommand "default.pa" { } ''
    #      sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
    #        ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
    #    '';
  };
}
