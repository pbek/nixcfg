{ config, pkgs, inputs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{  imports = [
    "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/modules/age.nix"
    (import "${home-manager}/nixos")
    ./git.nix
  ];

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
    # LC_ALL = "en_US.UTF-8";
    # LC_CTYPE = "en_US.UTF-8";
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

  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
        "https://nix-cache.qownnotes.org/main"
        "https://nix-cache.qownnotes.org/qownnotes"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "main:WYsIaF+ItMNE9Xt976bIGKSKp9jaaVeTzYlfqQqpP28="
        "qownnotes:7hN006Z7xgK5v97WKFo9u3qcVbZIXHtFmPPM3NPERpM="
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/pkgs/agenix.nix" {})
    (pkgs.callPackage "${builtins.fetchTarball "https://github.com/zhaofengli/attic/tarball/main"}/package.nix" {})
    neovim
    wget
    firefox
    kate
    kmail
    smartgithg
    fish
    # fishPlugins.done
    fishPlugins.fzf-fish
    # fishPlugins.forgit
    # fishPlugins.hydro
    # fishPlugins.grc
    # grc
    # nerdfonts

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
    # (pkgs.callPackage ../../apps/qc/default.nix { })
    qc

    less
    mc
    htop
    atop
    btop
    keepassxc
    inetutils
    dig
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
    # partition-manager
    gparted

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

  # https://rycee.gitlab.io/home-manager/options.html
  home-manager.users.omega = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "22.11";

    # allow unfree packages in nix-shell
    home.file.".config/nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';

    # enable starship prompt in fish shell, enableFishIntegration in the starship config did not work
    home.file.".config/fish/conf.d/starship.fish".text = ''
      starship init fish | source
    '';
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

  home-manager.users.omega = {
    xdg.desktopEntries = {
      qtcreator-nix-shell = {
        name = "Qt Creator with nix-shell";
        genericName = "C++ IDE for developing Qt applications";
        comment = "";
        icon = "${pkgs.qtcreator}/share/icons/hicolor/128x128/apps/QtProject-qtcreator.png";
        exec = "nix-shell /etc/nixos/shells/qt5.nix --run qtcreator";
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

    # enable https://starship.rs
    programs.starship =
    let
      flavour = "mocha"; # One of `latte`, `frappe`, `macchiato`, or `mocha`
    in {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      # https://starship.rs/config
      settings = {
        # add_newline = false;
        directory = {
          fish_style_pwd_dir_length = 3; # The number of characters to use when applying fish shell pwd path logic.
          truncation_length = 1; # The number of parent folders that the current directory should be truncated to.
          style = "bold sky";
        };
        git_branch = {
          style = "bold pink";
        };

        # format = "$all"; # Remove this line to disable the default prompt format

        # https://github.com/catppuccin/starship
        # https://github.com/catppuccin/starship/blob/main/palettes/mocha.toml
        palette = "catppuccin_${flavour}";
      } // builtins.fromTOML (builtins.readFile
        (pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "starship";
            rev = "3e3e54410c3189053f4da7a7043261361a1ed1bc";
            sha256 = "sha256-soEBVlq3ULeiZFAdQYMRFuswIIhI9bclIU8WXjxd7oY=";
          } + /palettes/${flavour}.toml));
    };
  };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    '';
}
