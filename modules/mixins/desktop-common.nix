{ config, pkgs, inputs, ... }:
{
  boot.kernel.sysctl = {
    # Note that inotify watches consume 1kB on 64-bit machines.
    "fs.inotify.max_user_watches" = 1048576; # default: 8192
    "fs.inotify.max_user_instances" = 1024; # default: 128
    "fs.inotify.max_queued_events" = 32768; # default: 16384
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # https://nixos.wiki/wiki/KDE
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.kdeconnect.enable = true;

  # Firewall
  # https://nixos.wiki/wiki/Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedTCPPorts = [ 22 ]; # SSH
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };


  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow flakes
#  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow some insecure packages to be installed
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    firefox
    kate
    kmail
    smartgithg
    fish
    magic-wormhole
    libsForQt5.yakuake
    xclip
    tmux
    nmap
    git
    jq
    fzf
    chromium
    topgrade
    filelight
    # Builds qtwebkit from source!
#    qt5.full
    qtcreator

#    qt5.qmake
#    libsForQt5.qt5.qt3d
#    libsForQt5.qt5.qtsensors
#    libsForQt5.qt5.qtserialport
#    libsForQt5.qt5.qtvirtualkeyboard
#    libsForQt5.qt5.qtwebchannel
#    libsForQt5.qt5.qtlottie
#    libsForQt5.qt5.qtvirtualkeyboard
#
#    libsForQt5.qt5.qtcharts
#    libsForQt5.qt5.qtconnectivity
#    libsForQt5.qt5.qtdeclarative
#    libsForQt5.qt5.qtdoc
#    libsForQt5.qt5.qtgraphicaleffects
#    libsForQt5.qt5.qtimageformats
#    libsForQt5.qt5.qtlocation
#    libsForQt5.qt5.qtmultimedia
#    libsForQt5.qt5.qtwebkit
#
#    libsForQt5.qt5.qtquickcontrols
#    libsForQt5.qt5.qtquickcontrols2
#    libsForQt5.qt5.qtscript
#    libsForQt5.qt5.qttranslations
#    libsForQt5.qt5.qtwebengine
#    libsForQt5.qt5.qtwebview

    libsForQt5.qt5.qmake
    libsForQt5.qt5.qttools
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtdeclarative
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5.qtwebsockets
    libsForQt5.qt5.qtx11extras
    libsForQt5.qt5.qtxmlpatterns
    libsForQt5.qt5.wrapQtAppsHook

#    qownnotes
    (pkgs.libsForQt5.callPackage ../../apps/qownnotes/default.nix { })
    (pkgs.callPackage ../../apps/qc/default.nix { })

    less
    mc
    htop
    atop
    git
    keepassxc
    inetutils
    nmap
    gnumake
    gcc
    gdb
    cmake
    chromium
    google-chrome
    wget
    vscode
    fwupd
    yubikey-manager
    pam_u2f
    yubico-pam
#    scdaemon
#    pcscd
    bluez
    exfatprogs
    f2fs-tools
    restic
    nextcloud-client
    ferdium
    topgrade
    ksnip
    sops
    ncdu

    libsForQt5.kwalletmanager
    libsForQt5.plasma-systemmonitor
    libsForQt5.kfind
    libsForQt5.kontact
    libsForQt5.kleopatra
    libsForQt5.kmail
    libsForQt5.korganizer
    libsForQt5.yakuake
    libsForQt5.spectacle
    libsForQt5.ark
    libsForQt5.bluedevil
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.gwenview
    libsForQt5.kaccounts-integration
    libsForQt5.kaccounts-providers
    libsForQt5.ksshaskpass
    libsForQt5.okular
    libsForQt5.plasma-browser-integration
    libsForQt5.plasma-disks
    libsForQt5.plasma-nm
    libsForQt5.plasma-pa
    libsForQt5.plasma-vault
    kdiff3
    partition-manager

    pinentry-curses
    pinentry-qt
    killall
    cryfs
    onlyoffice-bin
    gh

    # TU Graz
    vpnc
    networkmanager-vpnc
    openconnect
    networkmanager-openconnect
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
#  programs.ssh.startAgent = false;

  # Do garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Docker
  # https://nixos.wiki/wiki/Docker
  virtualisation.docker.enable = true;

  # Add Restic Security Wrapper
  # https://nixos.wiki/wiki/Restic
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "omega";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
