{ config, pkgs, inputs, username, termFontSize, ... }:
{
  imports = [
    ./desktop-common-minimum.nix
    ./git.nix
    ./espanso.nix
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Disable avahi to avoid security issues
  # https://discourse.nixos.org/t/cups-cups-filters-and-libppd-security-issues/52780
  services.avahi.enable = false;

  # Allow some insecure packages to be installed
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  environment.systemPackages = with pkgs; [
#    smartgithg
#    (pkgs.callPackage ../../apps/smartgithg/default.nix { })
#    gittyup
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
    pinentry-qt # For some reason this wasn't installed by the gpg settings
    cryfs
    onlyoffice-bin
    gh
    smartmontools
    lazydocker
    uutils-coreutils # GNU coreutils replacement

    # TU Graz
    vpnc
    networkmanager-vpnc
    openconnect
    networkmanager-openconnect
  ];

  programs.fish.shellAliases = {
    lzd = "lazydocker";

    # Replace GNU coreutils with uutils-coreutils
    hostid = "uutils-hostid";
    sum = "uutils-sum";
    yes = "uutils-yes";
    hostname = "uutils-hostname";
    factor = "uutils-factor";
    uptime = "uutils-uptime";
    rmdir = "uutils-rmdir";
    printf = "uutils-printf";
    od = "uutils-od";
    basename = "uutils-basename";
    cut = "uutils-cut";
    cat = "uutils-cat";
#    install = "uutils-install";
    rm = "uutils-rm";
    comm = "uutils-comm";
    mktemp = "uutils-mktemp";
    base64 = "uutils-base64";
    paste = "uutils-paste";
    readlink = "uutils-readlink";
    stdbuf = "uutils-stdbuf";
    mkdir = "uutils-mkdir";
#    echo = "uutils-echo";
    basenc = "uutils-basenc";
    sync = "uutils-sync";
    wc = "uutils-wc";
    users = "uutils-users";
    csplit = "uutils-csplit";
    fold = "uutils-fold";
    unlink = "uutils-unlink";
    sleep = "uutils-sleep";
    pinky = "uutils-pinky";
    truncate = "uutils-truncate";
    nproc = "uutils-nproc";
    dir = "uutils-dir";
    cksum = "uutils-cksum";
    timeout = "uutils-timeout";
    chmod = "uutils-chmod";
    expr = "uutils-expr";
    whoami = "uutils-whoami";
    tr = "uutils-tr";
#    test = "uutils-test";
    tail = "uutils-tail";
    who = "uutils-who";
    tac = "uutils-tac";
    tty = "uutils-tty";
    realpath = "uutils-realpath";
    mkfifo = "uutils-mkfifo";
    ls = "uutils-ls";
    logname = "uutils-logname";
    join = "uutils-join";
    groups = "uutils-groups";
    false = "uutils-false";
    env = "uutils-env";
    id = "uutils-id";
    dirname = "uutils-dirname";
    sort = "uutils-sort";
    stat = "uutils-stat";
    tee = "uutils-tee";
    nl = "uutils-nl";
    dircolors = "uutils-dircolors";
    expand = "uutils-expand";
    ptx = "uutils-ptx";
    pwd = "uutils-pwd";
    fmt = "uutils-fmt";
    dd = "uutils-dd";
    shred = "uutils-shred";
    uniq = "uutils-uniq";
    chroot = "uutils-chroot";
    du = "uutils-du";
    chown = "uutils-chown";
    chgrp = "uutils-chgrp";
    arch = "uutils-arch";
    tsort = "uutils-tsort";
    kill = "uutils-kill";
    mv = "uutils-mv";
    base32 = "uutils-base32";
    numfmt = "uutils-numfmt";
    mknod = "uutils-mknod";
    date = "uutils-date";
    printenv = "uutils-printenv";
    seq = "uutils-seq";
    pr = "uutils-pr";
    pathchk = "uutils-pathchk";
#    true = "uutils-true";
    touch = "uutils-touch";
    ln = "uutils-ln";
    cp = "uutils-cp --progress";
    head = "uutils-head";
    nice = "uutils-nice";
    link = "uutils-link";
    split = "uutils-split";
    df = "uutils-df";
    shuf = "uutils-shuf";
    vdir = "uutils-vdir";
    unexpand = "uutils-unexpand";
    uname = "uutils-uname";
    more = "uutils-more";
    hashsum = "uutils-hashsum";
    nohup = "uutils-nohup";
  };

  # Docker
  # https://nixos.wiki/wiki/Docker
  virtualisation.docker.enable = true;
  # Disable logging on desktop to prevent disk space issues and spamming the journal (but this causes no logging at all!)
  # https://docs.docker.com/engine/logging/configure/
  # Note: Doen't seem to do anything
#  virtualisation.docker.logDriver = "none";

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

    programs = {
      kitty = {
        enable = true;
        font = {
          name = "FiraCode Nerd Font";
          size = termFontSize;
        };
        shellIntegration = {
          enableFishIntegration = true;
          enableBashIntegration = true;
        };
      };

      # Sync your shell history across all your devices
      # https://docs.atuin.sh
      atuin = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        # https://docs.atuin.sh/configuration/config/
        # Writes ~/.config/atuin/config.toml
        settings = {
          sync_address = "https://atuin.bekerle.com";
          sync_frequency = "15m";
          key_path = "/home/${username}/.secrets/atuin-key";
          enter_accept = true;  # Enter runs command
          style = "compact";  # No extra box around UI
          inline_height = 32; # Max height of inline preview
          prefers_reduced_motion = true;  # No automatic time updates
#          sync.records = true; # v2 sync (not working)
          workspaces = true;  # Filter in directories with git repositories
        };
      };

      # Enable https://wezfurlong.org/wezterm/ for terminal with OSC 52 support for zellij clipboard via SSH
#      wezterm = {
#        enable = true;
#        # https://wezfurlong.org/wezterm/config/lua/wezterm/font.html?h=font
#        extraConfig = ''
#          return {
#            animation_fps = 1,
#            cursor_blink_rate = 0,
#            font = wezterm.font(
#              'FiraCode Nerd Font',
#              { weight = 'Medium' }
#            ),
#            font_size = ${toString termFontSize},
#            color_scheme = 'Breeze (Gogh)',
#            use_fancy_tab_bar = false,
#            tab_max_width = 32,
#            hide_tab_bar_if_only_one_tab = false,
#            keys = {
#              { key = 'LeftArrow', mods = 'SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
#              { key = 'RightArrow', mods = 'SHIFT', action = wezterm.action.ActivateTabRelative(1) },
#            },
#          }
#        '';
#      };
    };
  };
}
