{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userLogin;
  inherit (hokage) userNameLong;
  inherit (hokage) useInternalInfrastructure;
  inherit (hokage) excludePackages;

  inherit (lib)
    mkDefault
    ;
in
{
  # Set some fish config
  programs = {
    fish = {
      enable = true;
      shellInit = ''
        # Fix: Help messages to be shown in English, instead of German
        set -e LANGUAGE
      '';
      shellAliases = {
        gitc = "git commit";
        gitps = "git push";
        gitplr = "git pull --rec";
        gitpl = "git pull && git submodule update --init";
        gitsub = "git submodule update --init";
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
        # ping = "pingu";
        ping = "gping";
        tar = "ouch";
        ps = "procs";
        whois = "rdap";
        vim = "hx";
        nano = "micro";
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

    # fuzzy finder TUI
    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/television.nix
    television = {
      enable = true;
      # https://github.com/alexpasmantier/television/wiki/Shell-Autocompletion
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };

  # Define a user account. Don't forget to set a password with "passwd".
  users.users = lib.genAttrs hokage.users (_userName: {
    isNormalUser = true;
    description = mkDefault userNameLong;
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
  });

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
    # Use English for messages (e.g. error messages)
    # Although LANGUAGE still needed to be unset in fish shell
    LC_MESSAGES = "en_US.UTF-8";
  };

  # Configure console keymap
  console.keyMap = lib.mkDefault "de-latin1-nodeadkeys";

  networking = {
    networkmanager.enable = mkDefault true;
  };

  nix = {
    settings = {
      # Allow flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # To do a "nix-build --repair" without sudo
      # We still need that to not get a "lacks a signature by a trusted key" error when building on a remote machine
      # https://wiki.nixos.org/wiki/Nixos-rebuild
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
        gitFull # git and gitk
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
        # https://github.com/NixOS/nixpkgs/issues/454391
        bat-extras.batgrep # ripgrep with bat
        bat-extras.batman # man with bat
        tldr # man replacement
        fd # find replacement
        # television # fuzzy finder TUI
        # (callPackage ../../pkgs/television/package.nix { })
        zellij # terminal multiplexer (like tmux)
        netcat-openbsd # Netcat with -U parameter for libvirt
        nmap
        lazygit
        dogdns # dig replacement
        broot # fast directory switcher (has "br" alias for changing into directories)
        difftastic # Structural diff tool that compares files based on their syntax
        # pingu # ping, but more colorful
        gping # graphical ping
        sysz # fzf terminal UI for systemctl

        # textual is currently broken in unstable
        # https://github.com/NixOS/nixpkgs/pull/425707
        # isd # a better way to work with systemd units

        ouch # compress and decompress files
        procs # ps "replacement"
        just # command runner like make
        neosay # send messages to matrix room
        rdap # whois replacement
        lsof # list open files
        devenv # DevEnv CLI
        micro # Nano replacement
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
  # https://wiki.nixos.org/wiki/Restic
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = userLogin;
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  # Enable memory-safe implementation of the sudo command
  security.sudo-rs.enable = true;

  system = {
    # Create a symlink to the latest nixpkgs of the flake
    # See: https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798/18
    systemBuilderCommands = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';

    # Careful with this, see https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
    # Also see https://mynixos.com/nixpkgs/option/system.stateVersion
    stateVersion = "24.11";
  };

  # https://rycee.gitlab.io/home-manager/options.html
  # https://nix-community.github.io/home-manager/options.html#opt-home.file
  home-manager.users = lib.genAttrs hokage.usersWithRoot (_userName: {
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
      bash.enable = true;

      # Run nix-shell, etc. in the fish shell instead of bash
      nix-your-shell = {
        enable = true;
        enableFishIntegration = true;
      };

      # Tiling terminal multiplexer
      zellij = {
        enable = true;
        # Shell integrations are disabled, because they would open zellij as soon as the shells start
        enableFishIntegration = false;
        enableBashIntegration = false;
      };

      # A smarter cd command
      # https://github.com/ajeetdsouza/zoxide
      zoxide = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        options = [ "--cmd cd" ];
      };

      # Post-modern editor (like vim)
      helix = {
        enable = true;
        defaultEditor = useInternalInfrastructure;
        settings = {
          # https://helix-editor.vercel.app/reference/list-of-themes#catppuccin_mocha
          theme = "catppuccin_mocha";
        };
      };
    };
  });

  # Enable ZRAM swap to get more memory
  # https://search.nixos.org/options?channel=23.11&from=0&size=50&sort=relevance&type=packages&query=zram
  zramSwap = {
    enable = mkDefault true;
  };
}
