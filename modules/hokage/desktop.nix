{
  config,
  pkgs,
  inputs,
  lib,
  utils,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userLogin;
  inherit (hokage) useSecrets;
  inherit (hokage) termFontSize;
in
{
  config = lib.mkIf (hokage.role == "desktop") {
    # Enable CUPS to print documents.
    services.printing.enable = true;
    # Disable avahi to avoid security issues
    # https://discourse.nixos.org/t/cups-cups-filters-and-libppd-security-issues/52780
    services.avahi.enable = false;

    # Allow some insecure packages to be installed
    nixpkgs.config.permittedInsecurePackages = [
      "qtwebkit-5.212.0-alpha4"
    ];

    environment.systemPackages =
      with pkgs;
      let
        requiredPackages = [
        ];
        optionalPackages = [
          #    smartgithg
          #    (pkgs.callPackage ../../pkgs/smartgithg/default.nix { })
          #    gittyup
          #    (pkgs.libsForQt5.callPackage ../../pkgs/gittyup/default.nix { })
          kdiff3
          chromium
          hub

          loganalyzer
          #    (pkgs.libsForQt5.callPackage ../../pkgs/loganalyzer/default.nix { })
          #    noseyparker
          #    (pkgs.callPackage ../../pkgs/noseyparker/default.nix { })

          keepassxc
          gcc
          gdb
          cmake
          chromium
          google-chrome
          vscode
          (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
              github.copilot
              github.copilot-chat
            ];
          })
          yubikey-manager
          pam_u2f
          yubico-pam
          #    scdaemon
          #    pcscd
          exfatprogs
          f2fs-tools
          ferdium
          wireguard-tools
          nixpkgs-review
          nix-search-cli

          #    pinentry-curses
          pinentry-qt # For some reason this wasn't installed by the gpg settings
          cryfs
          onlyoffice-bin
          gh
          git-town # Git extension
          smartmontools
          lazydocker
          uutils-coreutils # GNU coreutils replacement
          inkscape
          nil # Nix language server for kate
          # marksman # Markdown language server for kate
          act # Run GitHub Actions locally
          # (callPackage ../../pkgs/zen-browser/package.nix {})
          gptcommit # Git commit message generator
        ];
      in
      requiredPackages ++ utils.removePackagesByName optionalPackages hokage.excludePackages;

    programs.fish.shellAliases = {
      lzd = "lazydocker";
      gits = "git town sync";
      gith = "git town hack";
      gitdel = "git town delete";

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
    # https://wiki.nixos.org/wiki/Docker
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

    # https://github.com/Aetf/kmscon
    services.kmscon = {
      enable = lib.mkDefault true;
      fonts = [
        {
          name = "Source Code Pro";
          package = pkgs.source-code-pro;
        }
      ];
      # https://github.com/Aetf/kmscon/blob/develop/src/kmscon_conf.c
      extraOptions = "--xkb-layout de";
    };

    # https://rycee.gitlab.io/home-manager/options.html
    # https://nix-community.github.io/home-manager/options.html#opt-home.file
    home-manager.users.${userLogin} = {
      # Set the path to the pia-manual repository and the userLogin and password for the PIA VPN script
      home.file."Scripts/pia.sh" = {
        text =
          if useSecrets then
            ''
              #!/usr/bin/env bash
              # PIA startup script
              set -e
              cd "${inputs.pia}"
              sudo VPN_PROTOCOL=wireguard DISABLE_IPV6=yes DIP_TOKEN=no AUTOCONNECT=true PIA_PF=false PIA_DNS=false PIA_USER=$(cat "${config.age.secrets.pia-user.path}") PIA_PASS=$(cat "${config.age.secrets.pia-pass.path}") ./run_setup.sh
            ''
          else
            "";
        executable = true;
      };

      programs = {
        # Terminal with OSC 52 support
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
  };
}
