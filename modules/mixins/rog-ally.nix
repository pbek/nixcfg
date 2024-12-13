{
  config,
  pkgs,
  userLogin,
  userNameLong,
  userEmail,
  lib,
  ...
}:

{
  imports = [
    ./users.nix
    ./desktop-common-minimum.nix
    ./audio.nix
    ./openssh.nix
    ./local-store-cache.nix
  ];

  networking = {
    networkmanager.enable = true;
  };

  # Virtual keyboard at lock screen does not work in plasma6!
  #  services.desktopManager.plasma6.enable = true;
  #  services.displayManager.defaultSession = "plasmax11";
  #  environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #    baloo
  #  ];

  services.xserver.desktopManager.plasma5.enable = true;

  # GTK themes are not applied in Wayland applications / Window Decorations missing / Cursor looks different
  # https://nixos.wiki/wiki/KDE#GTK_themes_are_not_applied_in_Wayland_applications_.2F_Window_Decorations_missing_.2F_Cursor_looks_different
  programs.dconf.enable = true;

  #  environment.systemPackages = with pkgs.kdePackages; [
  environment.systemPackages = with pkgs; [
    libsForQt5.kwalletmanager
    libsForQt5.plasma-systemmonitor
    libsForQt5.spectacle
    libsForQt5.ark
    libsForQt5.bluedevil
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.gwenview
    libsForQt5.okular
    libsForQt5.plasma-browser-integration
    libsForQt5.plasma-disks
    libsForQt5.plasma-nm
    libsForQt5.plasma-pa
    libsForQt5.kate

    onboard # On-screen keyboard
    google-chrome # Touch scrolling in Chrome
    #    heroic-unwrapped # Epic Games Store
    heroic # Epic Games Store
    lutris-unwrapped # Game manager

    ferdium
    #    qownnotes
    (pkgs.qt6Packages.callPackage ../../apps/qownnotes/default.nix { })
    qc
    #    (pkgs.callPackage ../../apps/qc/default.nix { })
    nextcloud-client

    wowup-cf
    #    (pkgs.callPackage ../../apps/wowup-cf/default.nix { })
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
    package = (pkgs.callPackage ../../apps/handheld-daemon/package.nix { }).override {
    };
  };
}
