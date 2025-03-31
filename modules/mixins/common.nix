{
  config,
  pkgs,
  inputs,
  lib,
  utils,
  cfg,
  ...
}:
let
  inherit (config.services.hokage) userLogin;
  inherit (config.services.hokage) userNameLong;
  inherit (config.services.hokage) useSecrets;
  inherit (config.services.hokage) useInternalInfrastructure;
  inherit (config.services.hokage) excludePackages;
  inherit (config.services.hokage) useAtuin;
in
{
  imports = [
    ./starship.nix
    ../services/hokage.nix
  ];

  # Set some fish config
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        gitc = "git commit";
        gitps = "git push";
        gitplr = "git pull --rec";
        gitpl = "git pull && git submodule update --init";
        gitpls = "git pull";
        gita = "git add -A";
        gitst = "git status";
        gitd = "git diff";
        gitds = "git diff --staged";
        gitl = "git log";
        vim = "nvim";
        ll = "eza -hal --icons --group-directories-first";
        fish-reload = "exec fish";
        lg = "lazygit";
        duai = "dua interactive";
        j = "just";
      };
      shellAbbrs = {
        killall = "pkill";
        less = "bat";
        #      cat = "bat";
        #      man = "tldr";
        man = "batman";
        du = "dua";
        ncdu = "dua interactive";
        df = "duf";
        tree = "erd";
        tmux = "zellij";
        dig = "dog";
        diff = "difft";
        ping = "pingu";
        tar = "ouch";
        ps = "procs";
        whois = "rdap";
        vim = "hx";
      };
    };

    bash.shellAliases = config.programs.fish.shellAliases;

    # yet-another-nix-helper
    # https://github.com/viperML/nh
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 14d --keep 4";
    };
  };

  # Define a user account. Don't forget to set a password with "passwd".
  users.users.${userLogin} = {
    isNormalUser = true;
    description = lib.mkDefault userNameLong;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"
      "input"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
    # Set empty password initially. Don't forget to set a password with "passwd".
    initialHashedPassword = "";
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

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  nix = {
    settings = {
      # Allow flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # To do a "nix-build --repair" without sudo
      # We still need that to not get a "lacks a signature by a trusted key" error when building on a remote machine
      # https://nixos.wiki/wiki/Nixos-rebuild
      trusted-users = [
        "root"
        "@wheel"
      ];

      # Above is more dangerous than below
      # https://fosstodon.org/@lhf/112773183844782048
      # https://github.com/NixOS/nix/issues/9649#issuecomment-1868001568
      trusted-substituters = [
        "root"
        "@wheel"
      ];

      # Allow fallback from local caches
      connect-timeout = 5;
      fallback = true;
    };

    # Use symlink to the latest nixpkgs of the flake as nixpkgs, e.g. for nix-shell
    nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];

    # Try out the latest nix version
    package = pkgs.nixVersions.latest;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages =
    with pkgs;
    let
      requiredPackages = [
      ];
      optionalPackages = [
        # neovim # replaced by helix
        wget
        fish
        tmux
        git
        gitflow
        jq
        less
        mc
        htop
        atop
        btop
        inetutils
        dig
        gnumake
        restic
        nix-tree # look into the nix store
        erdtree # tree replacement
        dust # disk usage (du) replacement
        duf # disk free (df) replacement
        dua # disk usage (du) replacement
        ranger # midnight commander replacement (not really)
        ripgrep # grep replacement
        eza # ls replacement
        bat # less replacement with syntax highlighting
        bat-extras.batgrep # ripgrep with bat
        bat-extras.batman # man with bat
        tldr # man replacement
        fd # find replacement
        zellij # terminal multiplexer (like tmux)
        netcat-gnu
        nmap
        lazygit
        dogdns # dig replacement
        broot # fast directory switcher (has "br" alias for changing into directories)
        difftastic # Structural diff tool that compares files based on their syntax
        pingu # ping, but more colorful
        sysz # fzf terminal UI for systemctl
        isd # a better way to work with systemd units
        ouch # compress and decompress files
        procs # ps "replacement"
        just # command runner like make
        neosay # send messages to matrix room
        rdap # whois replacement
      ];
    in
    requiredPackages ++ utils.removePackagesByName optionalPackages excludePackages;

  # Do garbage collection
  # Disabled for "programs.nh.clean.enable"
  #  nix.gc = {
  #    automatic = true;
  #    dates = "weekly";
  #    options = "--delete-older-than 20d";
  #  };

  # Add Restic Security Wrapper
  # https://nixos.wiki/wiki/Restic
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = userLogin;
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  system = {
    # Create a symlink to the latest nixpkgs of the flake
    # See: https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798/18
    extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';

    # Careful with this, see https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    # Also see https://mynixos.com/nixpkgs/option/system.stateVersion
    stateVersion = "24.11";
  };

  # https://rycee.gitlab.io/home-manager/options.html
  # https://nix-community.github.io/home-manager/options.html#opt-home.file
  home-manager.users.${userLogin} = {
    # The home.stateVersion option does not have a default and must be set
    home.stateVersion = "24.11";

    # Enable fish and bash in home-manager to use enableFishIntegration and enableBashIntegration
    programs = {
      # Enable https://direnv.net/
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      fish.enable = true;
      bash = {
        enable = true;
        # Add atuin init to bashrc, because it doesn't work with bashIntegration
        # But it still doesn't add anything to the Atuin history
        bashrcExtra = lib.mkIf useAtuin ''
          eval "$(${pkgs.atuin}/bin/atuin init --disable-up-arrow bash)"
        '';
      };

      # A smarter cd command
      # https://github.com/ajeetdsouza/zoxide
      zoxide = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        options = [ "--cmd cd" ];
      };

      # Blazing fast terminal file manager written in Rust
      # https://github.com/sxyazi/yazi
      yazi = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
      };

      # Exit Yazi to the current path
      # https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
      fish.functions = {
        yy = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };

      # Post-modern editor (like vim)
      helix = {
        enable = true;
        settings = {
          # https://helix-editor.vercel.app/reference/list-of-themes#catppuccin_mocha
          theme = "catppuccin_mocha";
        };
      };

      # Sync your shell history across all your devices
      # https://docs.atuin.sh
      atuin = lib.mkIf useAtuin {
        package = pkgs.atuin.overrideAttrs (oldAttrs: rec {
          patches = oldAttrs.patches ++ [
            # Fix for up binding key for fish 4.0
            # https://github.com/atuinsh/atuin/pull/2616
            ../../apps/atuin/2616.patch
          ];
        });
        enable = true;
        daemon.enable = true;
        enableFishIntegration = true;
        # Writing to the atuin history doesn't work with bash
        # See https://github.com/nix-community/home-manager/issues/5958
        enableBashIntegration = false;
        # https://docs.atuin.sh/configuration/config/
        # Writes ~/.config/atuin/config.toml
        settings = {
          sync_address =
            if useInternalInfrastructure then "https://atuin.bekerle.com" else "https://api.atuin.sh";
          sync_frequency = "15m";
          key_path =
            if useSecrets then "/home/${userLogin}/.secrets/atuin-key" else "~/.local/share/atuin/key";
          enter_accept = true; # Enter runs command
          style = "compact"; # No extra box around UI
          inline_height = 32; # Maximum number of lines Atuin’s interface should take up
          prefers_reduced_motion = true; # No automatic time updates
          #          sync.records = true; # v2 sync (not working)
          workspaces = true; # Filter in directories with git repositories
          filter_mode = "workspace"; # Filter in directories with git repositories by default
          ctrl_n_shortcuts = true; # Use Ctrl, because Alt is taken by Ghostty
          # Fixes ZFS issues
          # See https://github.com/atuinsh/atuin/issues/952
          daemon = {
            enabled = true;
            systemd_socket = true;
          };
        };
      };
    };
  };

  # Enable ZRAM swap to get more memory
  # https://search.nixos.org/options?channel=23.11&from=0&size=50&sort=relevance&type=packages&query=zram
  zramSwap = {
    enable = lib.mkDefault true;
  };
}
