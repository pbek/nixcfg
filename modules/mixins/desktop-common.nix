{ config, pkgs, inputs, username, weztermFontSize, ... }:
{
  imports = [
    ./common.nix
    ./git.nix
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
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.sddm.enable = true;
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
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
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

  # https://nixos.wiki/wiki/Fonts
  # fonts for starship
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  environment.systemPackages = with pkgs; [
#    (pkgs.callPackage "${builtins.fetchTarball {
#      url = "https://github.com/zhaofengli/attic/tarball/main";
#      sha256 = "sha256:0p9n5m0qc34ji6hljlw4ns8sqyn6861k18crwxcw6v9pwmjqxgzl";
#    }}/package.nix" {})
    inputs.attic.packages.x86_64-linux.default
    inputs.agenix.packages.x86_64-linux.default
    firefox
    smartgithg
    gittyup
    kdiff3

    magic-wormhole
    xclip
    fzf
    fishPlugins.fzf-fish
    chromium
    qtcreator
    hub
    usbutils  # lsusb

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
    sniffnet
    wireguard-tools
    nixpkgs-review

    pinentry-curses
    pinentry-qt
    cryfs
    onlyoffice-bin
    gh
    smartmontools

    kdePackages.kwalletmanager
    kdePackages.plasma-systemmonitor
    kdePackages.kfind
    kdePackages.kontact
    kdePackages.akonadiconsole
    kdePackages.kleopatra
    kdePackages.kmail
    kdePackages.korganizer
    kdePackages.kaddressbook
    kdePackages.yakuake
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.bluedevil
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.gwenview
    kdePackages.kaccounts-integration
    kdePackages.kaccounts-providers
    kdePackages.ksshaskpass
    kdePackages.okular
    kdePackages.plasma-browser-integration
    kdePackages.plasma-disks
    kdePackages.plasma-nm
    kdePackages.plasma-pa
    kdePackages.plasma-vault
    kdePackages.kate
    kdePackages.kmail
    kdePackages.akonadi
    kdePackages.kdepim-runtime
    kdePackages.filelight

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

  users.users.${username} = {
    openssh.authorizedKeys.keys = [
      # Yubikey public key
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@yubikey"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3ySO2ND+Za5z67zWrqMONDXLKBDgOKGuGRXJ2fNKfeN84lPkok/YTNifzvKAFWLB8tvzdQITUV2AaTWt7F33iJpfmJBG1OO2tgsr9SLUpwgthWMrA4FwsFI5/jhw4gQAa5i6R7nkKxOjaXe7BoS82OyIpIhXXpm5TDzMwWelJUBPhYxcDvoZD2BU0SVW3/uFBYIlHsQ5nNyoNtkDf6iJGRF6MlreAI2gyJMcnOm/DxhJ8l1D7BFZ1rPncDCOCn8YnFykp/R58VJBX2dosFaZQr7/17+exDivB4kPlpmWQS74Xej16QsHaqxocS/s0Vj5uQdI8Hk4fLum4yFf5Rxk7 omega@rsa"
    ];
  };

  # https://rycee.gitlab.io/home-manager/options.html
  # https://nix-community.github.io/home-manager/options.html#opt-home.file
  home-manager.users.${username} = {
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

    # Add config for zellij
    home.file.".config/zellij" = {
      source = ../../files/zellij;
    };

    xdg.desktopEntries = {
      qtcreator-nix-shell = {
        name = "Qt Creator with nix-shell";
        genericName = "C++ IDE for developing Qt applications";
        comment = "";
#        icon = "${pkgs.qtcreator-qt6}/share/icons/hicolor/128x128/apps/QtProject-qtcreator.png";
        icon = "${pkgs.qtcreator}/share/icons/hicolor/128x128/apps/QtProject-qtcreator.png";
        exec = "nix-shell /home/${username}/.shells/qt5.nix --run qtcreator";
        terminal = false;
        categories = [ "Development" ];
      };
    };

    # Enable https://direnv.net/
    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    # Enable https://wezfurlong.org/wezterm/ for terminal with OSC 52 support for zellij clipboard via SSH
    programs.wezterm = {
      enable = true;
      # https://wezfurlong.org/wezterm/config/lua/wezterm/font.html?h=font
      extraConfig = ''
        return {
          font = wezterm.font(
            'FiraCode Nerd Font',
            { weight = 'Medium' }
          ),
          font_size = ${weztermFontSize},
          color_scheme = 'Breeze (Gogh)',
          use_fancy_tab_bar = false,
          tab_max_width = 32,
          hide_tab_bar_if_only_one_tab = false,
          keys = {
            { key = 'LeftArrow', mods = 'SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
            { key = 'RightArrow', mods = 'SHIFT', action = wezterm.action.ActivateTabRelative(1) },
          },
        }
      '';
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

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
