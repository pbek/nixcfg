{ config, pkgs, inputs, ... }:
{ imports = [
    ./git.nix
  ];

  boot.kernel.sysctl = {
    # Note that inotify watches consume 1kB on 64-bit machines.
    "fs.inotify.max_user_watches" = 1048576; # default: 8192
    "fs.inotify.max_user_instances" = 1024; # default: 128
    "fs.inotify.max_queued_events" = 32768; # default: 16384
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    # LC_ALL = "de_AT.UTF-8";
    LC_ADDRESS = "de_AT.UTF-8";
    LC_COLLATE = "de_AT.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
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

  environment.plasma5.excludePackages = with pkgs; [
    # Did not work
    partition-manager
  ];


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

      # Allow flakes
      experimental-features = [ "nix-command" "flakes" ];

      # To do a "nix-build --repair" without sudo
      trusted-users = [ "root" "@wheel" ];
    };
  };

  # https://nixos.wiki/wiki/Fonts
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
#    (pkgs.callPackage "${builtins.fetchTarball {
#      url = "https://github.com/zhaofengli/attic/tarball/main";
#      sha256 = "sha256:0p9n5m0qc34ji6hljlw4ns8sqyn6861k18crwxcw6v9pwmjqxgzl";
#    }}/package.nix" {})
    inputs.attic.packages.x86_64-linux.default
    inputs.agenix.packages.x86_64-linux.default
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
    # always says "Too many open files" while building
#    qtcreator-qt6
    qtcreator
    tree

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

    qownnotes
#    (pkgs.qt6Packages.callPackage ../../apps/qownnotes/default.nix { })
    qc
#    (pkgs.callPackage ../../apps/qc/default.nix { })
    loganalyzer
#    (pkgs.libsForQt5.callPackage ../../apps/loganalyzer/default.nix { })
    (pkgs.callPackage ../../apps/noseyparker/default.nix { })

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
    sniffnet
    wireguard-tools
    nixpkgs-review
    ranger
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
    # partition-manager
    gparted

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

  # Do garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 20d";
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
      {
        allowUnfree = true;
      }
    '';

    # thefuck for fish shell
    home.file.".config/fish/conf.d/thefuck.fish".text = ''
      thefuck --alias | source
    '';

    # enable starship prompt in fish shell, enableFishIntegration in the starship config did not work
    home.file.".config/fish/conf.d/starship.fish".text = ''
      starship init fish | source
    '';

    # Enable starship for bash (did not work)
    # programs.bash.bashrcExtra = ''
    #   eval "$(starship init bash)"
    # '';

    # Enable starship for bash
    home.file.".bash_aliases".text = ''
      eval "$(starship init bash)"
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

  home-manager.users.omega = {
    xdg.desktopEntries = {
      qtcreator-nix-shell = {
        name = "Qt Creator with nix-shell";
        genericName = "C++ IDE for developing Qt applications";
        comment = "";
#        icon = "${pkgs.qtcreator-qt6}/share/icons/hicolor/128x128/apps/QtProject-qtcreator.png";
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
      # Lookup icons: https://www.nerdfonts.com/cheat-sheet
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
        username = {
          disabled = false;
          show_always = true;
        };
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
        hostname = {
          ssh_only = false;
          # leaving out the "in" at the end because there is not $directory 
          # setting afterwards any more
          format = "[$ssh_symbol$hostname]($style) ";
        };
        # https://starship.rs/config/#shell
        shell = {
          disabled = false;
          # format = "\\[[$indicator]($style)\\] ";
          style = "gray";
          fish_indicator = "󰈺";
          # bash_indicator = "b";
        };
        status.disabled = false;

        # Move the directory to the second line
        # https://starship.rs/config/#default-prompt-format
        format = "$all$directory$status$character";

        # format = "$username$hostname$localip$shlvl$singularity$kubernetes$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$swift$terraform$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$battery$time$status$os$container$shell$directory$character";

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
}
