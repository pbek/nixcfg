{ config, pkgs, inputs, ... }:
{
  imports = [
    ./common.nix
    ./espanso.nix
  ];

  boot.kernel.sysctl = {
    # Note that inotify watches consume 1kB on 64-bit machines.
    "fs.inotify.max_user_watches" = 1048576; # default: 8192
    "fs.inotify.max_user_instances" = 1024; # default: 128
    "fs.inotify.max_queued_events" = 32768; # default: 16384
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # https://nixos.wiki/wiki/KDE
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.kdeconnect.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow some insecure packages to be installed
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://nix-cache.qownnotes.org/main"
        "https://nix-cache.qownnotes.org/qownnotes"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "main:WYsIaF+ItMNE9Xt976bIGKSKp9jaaVeTzYlfqQqpP28="
        "qownnotes:7hN006Z7xgK5v97WKFo9u3qcVbZIXHtFmPPM3NPERpM="
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
#    (pkgs.callPackage "${builtins.fetchTarball {
#      url = "https://github.com/zhaofengli/attic/tarball/main";
#      sha256 = "sha256:0p9n5m0qc34ji6hljlw4ns8sqyn6861k18crwxcw6v9pwmjqxgzl";
#    }}/package.nix" {})
    inputs.attic.packages.x86_64-linux.default
    inputs.agenix.packages.x86_64-linux.default
    firefox
    kate
    kmail
    smartgithg
    gittyup

    magic-wormhole
    libsForQt5.yakuake
    xclip
    nmap
    fzf
    chromium
    filelight
    # Builds qtwebkit from source!
#    qt5.full
    # always says "Too many open files" while building
#    qtcreator-qt6
    qtcreator
    tree
    hub
    usbutils  # lsusb

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

    # libsForQt5.qt5.qmake
    # libsForQt5.qt5.qttools
    # libsForQt5.qt5.qtbase
    # libsForQt5.qt5.qtdeclarative
    # libsForQt5.qt5.qtsvg
    # libsForQt5.qt5.qtwayland
    # libsForQt5.qt5.qtwebsockets
    # libsForQt5.qt5.qtx11extras
    # libsForQt5.qt5.qtxmlpatterns
    # libsForQt5.qt5.wrapQtAppsHook

#    qownnotes
    (pkgs.qt6Packages.callPackage ../../apps/qownnotes/default.nix { })
    qc
#    (pkgs.callPackage ../../apps/qc/default.nix { })
    loganalyzer
#    (pkgs.libsForQt5.callPackage ../../apps/loganalyzer/default.nix { })
#    noseyparker
#    (pkgs.callPackage ../../apps/noseyparker/default.nix { })

    keepassxc
    gcc
    gdb
    cmake
    chromium
    google-chrome
    vscode
    yubikey-manager
    pam_u2f
    yubico-pam
#    scdaemon
#    pcscd
    bluez
    exfatprogs
    f2fs-tools
    nextcloud-client
    ferdium
    topgrade
    ksnip
    sniffnet
    wireguard-tools
    nixpkgs-review
    nix-tree

    libsForQt5.kwalletmanager
    libsForQt5.plasma-systemmonitor
    libsForQt5.kfind
    libsForQt5.kontact
    libsForQt5.akonadiconsole
    libsForQt5.kleopatra
    libsForQt5.kmail
    libsForQt5.korganizer
    libsForQt5.kaddressbook
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

    pinentry-curses
    pinentry-qt
    cryfs
    onlyoffice-bin
    gh
    smartmontools

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

  # Enable Fwupd
  # https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  # Enable Netbird Wireguard VPN service
  services.netbird.enable = true;

  # Enable resoved to let wireguard set a DNS
  services.resolved.enable = true;

  # https://rycee.gitlab.io/home-manager/options.html
  # https://nix-community.github.io/home-manager/options.html#opt-home.file
  home-manager.users.omega = {
    # allow unfree packages in nix-shell
    home.file.".config/nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
      }
    '';

    # thefuck for fish shell
    home.file.".config/fish/conf.d/thefuck.fish".text = ''
      thefuck --alias | source
    '';

    # Set the path to the pia-manual repository and the username and password for the PIA VPN script
    home.file."Scripts/pia.sh" = {
      text = ''
        #!/usr/bin/env bash
        # PIA startup script
        set -e
        cd "${inputs.pia}"
        sudo VPN_PROTOCOL=wireguard DISABLE_IPV6=yes DIP_TOKEN=no AUTOCONNECT=true PIA_PF=false PIA_DNS=false PIA_USER=$(cat "${config.age.secrets.pia-user.path}") PIA_PASS=$(cat "${config.age.secrets.pia-pass.path}") ./run_setup.sh
      '';
      executable = true;
    };

    # Set up "shells" directory (e.g. for JetBrains IDEs and QtCreator)
    home.file.".shells" = {
      source = ../../files/shells;
    };

    home.file.".local/share/kservices5" = {
      source = ../../files/kservices5;
    };
  };

  # Disable wakeup from USB devices
  powerManagement.powerDownCommands = ''
    for f in /sys/bus/usb/devices/*/power/wakeup
    do
      echo "disabled" > $f
    done
  '';

  # https://github.com/NixOS/nixpkgs/pull/66480/files
  programs.fuse.userAllowOther = true;

  programs.thefuck.enable = true;

  # KDE partition-manager doesn't work when installed directly
  programs.partition-manager.enable = true;

  home-manager.users.omega = {
    xdg.desktopEntries = {
      qtcreator-nix-shell = {
        name = "Qt Creator with nix-shell";
        genericName = "C++ IDE for developing Qt applications";
        comment = "";
#        icon = "${pkgs.qtcreator-qt6}/share/icons/hicolor/128x128/apps/QtProject-qtcreator.png";
        icon = "${pkgs.qtcreator}/share/icons/hicolor/128x128/apps/QtProject-qtcreator.png";
        exec = "nix-shell /home/omega/.shells/qt5.nix --run qtcreator";
        terminal = false;
        categories = [ "Development" ];
      };
    };

    # enable https://direnv.net/
    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
