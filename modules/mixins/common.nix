{ config, pkgs, inputs, username, lib, ... }:
{
  imports = [
    ./starship.nix
  ];

  # Set some fish config
  programs.fish = {
    enable = true;
    shellAliases = {
      gitc = "git commit";
      gitps = "git push";
      gitplr = "git pull --rec";
      gitpl = "git pull && git submodule update --init";
      gita = "git add -A";
      gits = "git status";
      gitd = "git diff";
      gitds = "git diff --staged";
      gitl = "git log";
      vim = "nvim";
      ll = "eza -al";
      fish-reload = "exec fish";
      lg = "lazygit";
    };
    shellAbbrs = {
      killall = "pkill";
      less = "bat";
#      cat = "bat";
#      man = "tldr";
      man = "batman";
      du = "dua";
      df = "duf";
      tree = "erd";
      tmux = "zellij";
      dig = "dog";
    };
  };

  programs.bash.shellAliases = config.programs.fish.shellAliases;

  # Define a user account. Don't forget to set a password with "passwd".
  users.users.${username} = {
    isNormalUser = true;
    description = lib.mkDefault "Patrizio Bekerle";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" "input" ];
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
      experimental-features = [ "nix-command" "flakes" ];

      # To do a "nix-build --repair" without sudo
      trusted-users = [ "root" "@wheel" ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
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
    nix-tree  # look into the nix store
    erdtree # tree replacement
    ncdu  # disk usage (du) replacement
    duf # disk free (df) replacement
    dua # disk usage (du) replacement
    ranger  # midnight commander replacement (not really)
    ripgrep # grep replacement
    eza # ls replacement
    bat # less replacement with syntax highlighting
    bat-extras.batgrep  # ripgrep with bat
    bat-extras.batman # man with bat
    tldr  # man replacement
    fd  # find replacement
    zellij  # terminal multiplexer (like tmux)
    netcat-gnu
    nmap
    lazygit
    dogdns  # dig replacement
    broot # fast directory switcher (has "br" alias for changing into directories)
  ];

  # Do garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 20d";
  };

  # Add Restic Security Wrapper
  # https://nixos.wiki/wiki/Restic
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = username;
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

    stateVersion = "24.11";
  };

  # Use symlink to the latest nixpkgs of the flake as nixpkgs, e.g. for nix-shell
  nix.nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];

  # https://rycee.gitlab.io/home-manager/options.html
  # https://nix-community.github.io/home-manager/options.html#opt-home.file
  home-manager.users.${username} = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "24.11";

    # Enable fish and bash in home-manager to use enableFishIntegration and enableBashIntegration
    programs = {
      fish.enable = true;
      bash.enable = true;

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
    };
  };

  # Enable ZRAM swap to get more memory
  # https://search.nixos.org/options?channel=23.11&from=0&size=50&sort=relevance&type=packages&query=zram
  zramSwap = {
    enable = true;
  };
}
