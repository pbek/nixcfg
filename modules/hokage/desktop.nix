{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  inherit (config) hokage;
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

          # (pkgs.callPackage ../../pkgs/proton-authenticator/package.nix { })
          proton-authenticator

          # (pkgs.callPackage ../../pkgs/nixbit/package.nix { })

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
          onlyoffice-desktopeditors
          gh
          github-copilot-cli
          git-town # Git extension
          smartmontools
          lazydocker
          inkscape
          nil # Nix language server for kate
          # marksman # Markdown language server for kate
          act # Run GitHub Actions locally
          # (callPackage ../../pkgs/zen-browser/package.nix {})
          gptcommit # Git commit message generator

          aspell # Dictionaries for QOwnNotes
          aspellDicts.en
          aspellDicts.de

          lurk # strace "replacement"

          signal-desktop
          # telegram-desktop
          # whatsapp-electron
        ];
      in
      requiredPackages ++ utils.removePackagesByName optionalPackages hokage.excludePackages;

    programs.fish = {
      shellAliases = {
        lzd = "lazydocker";
        gits = "git town sync";
        gith = "git town hack";
        gitdel = "git town delete";
        oc = "AZURE_RESOURCE_NAME=zid-digitalisation-coding opencode";
      };

      shellAbbrs = {
        strace = "lurk";
      };
    };

    # Docker
    # https://wiki.nixos.org/wiki/Docker
    virtualisation.docker.enable = true;
    # Disable logging on desktop to prevent disk space issues and spamming the journal (but this causes no logging at all!)
    # https://docs.docker.com/engine/logging/configure/
    # Note: Doesn't seem to do anything
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
    home-manager.users = lib.genAttrs hokage.users (_userName: {
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
    });
  };
}
