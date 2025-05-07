{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.hokage) userLogin;
  inherit (config.hokage) userNameLong;
  inherit (config.hokage) userEmail;
in
{
  imports = [
    ./users.nix
    ./desktop-common-minimum.nix
    ./openssh.nix
    ./local-store-cache.nix
  ];

  networking = {
    networkmanager.enable = true;
  };

  # You need to set `maliit` in the Virtual Keyboard settings in the System Settings to use the virtual keyboard
  # And in the lock screen, you need to click the "Enter" button once so the virtual keyboard appears
  # See https://github.com/NixOS/nixpkgs/issues/303526#issuecomment-2692831998
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # GTK themes are not applied in Wayland applications / Window Decorations missing / Cursor looks different
  # https://nixos.wiki/wiki/KDE#GTK_themes_are_not_applied_in_Wayland_applications_.2F_Window_Decorations_missing_.2F_Cursor_looks_different
  programs.dconf.enable = true;

  #  environment.systemPackages = with pkgs.kdePackages; [
  environment.systemPackages = with pkgs; [
    kdePackages.kwalletmanager
    kdePackages.plasma-systemmonitor
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.bluedevil
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.plasma-browser-integration
    kdePackages.plasma-disks
    kdePackages.plasma-nm
    kdePackages.plasma-pa
    kdePackages.kate

    onboard # On-screen keyboard
    google-chrome # Touch scrolling in Chrome
    #    heroic-unwrapped # Epic Games Store
    heroic # Epic Games Store
    lutris-unwrapped # Game manager

    ferdium
    #    qownnotes
    (pkgs.qt6Packages.callPackage ../../pkgs/qownnotes/package.nix { })
    qc
    #    (pkgs.callPackage ../../pkgs/qc/default.nix { })
    nextcloud-client

    wowup-cf
    #    (pkgs.callPackage ../../pkgs/wowup-cf/default.nix { })
    ryubing # Nintendo Switch emulator
    qjoypad # Joystick mapper
    maliit-keyboard # Virtual keyboard
  ];

  # https://nixos.wiki/wiki/steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # https://rycee.gitlab.io/home-manager/options.html
  home-manager.users.${userLogin} = {
    programs.git = {
      enable = true;
      # use "git diff --no-ext-diff" for creating patches!
      difftastic.enable = true;
      userName = lib.mkDefault userNameLong;
      userEmail = lib.mkDefault userEmail;
      ignores = [
        ".idea"
        ".direnv"
      ];
    };
  };

  # Touch screen gestures
  services.touchegg.enable = true;

  #  # In addition to audio.nix we want to enable low-latency audio
  #  # https://github.com/fufexan/nix-gaming?tab=readme-ov-file#pipewire-low-latency
  #  services.pipewire = {
  #    lowLatency = {
  #      # enable this module
  #      enable = true;
  #      # defaults (no need to be set unless modified)
  #      quantum = 64;
  #      rate = 48000;
  #    };
  #  };

  # https://nixos.wiki/wiki/PipeWire#Low-latency_setup
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    context.properties = {
      default.clock.rate = 48000;
      default.clock.quantum = 32;
      default.clock.min-quantum = 32;
      default.clock.max-quantum = 32;
    };
  };

  # Enable asusctl daemon.
  services.asusd.enable = lib.mkDefault true;

  services.handheld-daemon = {
    enable = true;
    user = userLogin;
    package = (pkgs.callPackage ../../pkgs/handheld-daemon/package.nix { }).override {
    };
  };

  environment.sessionVariables = {
    # High DPI for ryubing
    AVALONIA_GLOBAL_SCALE_FACTOR = 2;
  };

  hokage = {
    # Turn off default graphical system, we want to use our own configuration
    useGraphicalSystem = false;
    termFontSize = 15.0;
  };
}
