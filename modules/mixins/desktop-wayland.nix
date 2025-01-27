{
  config,
  pkgs,
  inputs,
  ...
}:
let
  userLogin = config.services.hokage.userLogin;
in
{
  imports = [
    ./desktop-common-plasma6.nix
#    ./espanso-latest.nix
  ];

  services.displayManager.defaultSession = "plasma";

  # Launch SDDM in Wayland too
  # https://nixos.wiki/wiki/KDE#Launch_SDDM_in_Wayland_too
  services.displayManager.sddm.wayland.enable = true;

  # KMail Renders Blank Messages
  # https://nixos.wiki/wiki/KDE#KMail_Renders_Blank_Messages
  environment.sessionVariables = {
    NIX_PROFILES = "${pkgs.lib.concatStringsSep " " (
      pkgs.lib.reverseList config.environment.profiles
    )}";
  };

  environment.systemPackages = with pkgs; [
    # Add missing dependency for espanso
    wl-clipboard
  ];

  home-manager.users.${userLogin} = {
    xdg.desktopEntries = {
      ferdium-wayland = {
        name = "Ferdium Wayland";
        genericName = "Messaging Client";
        comment = "Desktop app bringing all your messaging services into one installable";
        icon = "ferdium";
        exec = "ferdium --ozone-platform=wayland --enable-features=WebRTCPipeWireCapturer,WaylandWindowDecorations";
        terminal = false;
        mimeType = [ "x-scheme-handler/ferdium" ];
        categories = [
          "Network"
          "InstantMessaging"
        ];
      };
    };
  };
}
