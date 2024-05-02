{ config, pkgs, inputs, username, weztermFontSize, ... }:
{
  imports = [
    ./desktop-common-minimum.nix
    ./git.nix
    ./espanso.nix
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Allow some insecure packages to be installed
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  environment.systemPackages = with pkgs; [
    smartgithg
    gittyup
#    (pkgs.libsForQt5.callPackage ../../apps/gittyup/default.nix { })
    kdiff3
    chromium
    qtcreator
    hub

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
    exfatprogs
    f2fs-tools
    ferdium
    topgrade
    sniffnet
    wireguard-tools
    nixpkgs-review
    nix-search-cli
    kitty # Terminal with OSC 52 support

#    pinentry-curses
#    pinentry-qt
    cryfs
    onlyoffice-bin
    gh
    smartmontools
    lazydocker

    # TU Graz
    vpnc
    networkmanager-vpnc
    openconnect
    networkmanager-openconnect
  ];

  programs.fish.shellAliases = {
    ldo = "lazydocker";
  };

  # Docker
  # https://nixos.wiki/wiki/Docker
  virtualisation.docker.enable = true;

  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
#  programs.ssh.startAgent = false;

  # Enable resoved to let wireguard set a DNS
  services.resolved.enable = true;

  # https://rycee.gitlab.io/home-manager/options.html
  # https://nix-community.github.io/home-manager/options.html#opt-home.file
  home-manager.users.${username} = {
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
      nix-direnv.enable = true;
    };

    # Enable https://wezfurlong.org/wezterm/ for terminal with OSC 52 support for zellij clipboard via SSH
    programs.wezterm = {
      enable = true;
      # https://wezfurlong.org/wezterm/config/lua/wezterm/font.html?h=font
      extraConfig = ''
        return {
          animation_fps = 1,
          cursor_blink_rate = 0,
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
}
