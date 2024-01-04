{ config, pkgs, inputs, ... }:
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
      gitpl = "git pull --rec";
      gita = "git add -A";
      gits = "git status";
      gitd = "git diff";
      gitl = "git log";
      vim = "nvim";
      ll = "eza -al";
    };
    shellAbbrs = {
      killall = "pkill";
    };
  };

  programs.bash.shellAliases = config.programs.fish.shellAliases;

  # Define a user account. Don't forget to set a password with ?passwd?.
  users.users.omega = {
    isNormalUser = true;
    description = "Patrizio Bekerle";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
    # Yubikey public key
    openssh.authorizedKeys.keys = [
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@yubikey"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3ySO2ND+Za5z67zWrqMONDXLKBDgOKGuGRXJ2fNKfeN84lPkok/YTNifzvKAFWLB8tvzdQITUV2AaTWt7F33iJpfmJBG1OO2tgsr9SLUpwgthWMrA4FwsFI5/jhw4gQAa5i6R7nkKxOjaXe7BoS82OyIpIhXXpm5TDzMwWelJUBPhYxcDvoZD2BU0SVW3/uFBYIlHsQ5nNyoNtkDf6iJGRF6MlreAI2gyJMcnOm/DxhJ8l1D7BFZ1rPncDCOCn8YnFykp/R58VJBX2dosFaZQr7/17+exDivB4kPlpmWQS74Xej16QsHaqxocS/s0Vj5uQdI8Hk4fLum4yFf5Rxk7 omega@rsa"
    ];
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
    fishPlugins.fzf-fish
    tmux
    git
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
    ncdu  # disk usage (du) replacement
    duf # disk free (df) replacement
    dua # disk usage (du) replacement
    ranger  # midnight commander replacement
    ripgrep # grep replacement
    eza # ls replacement
  ];

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

  system = {
    # Create a symlink to the latest nixpkgs of the flake
    # See: https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798/18
    extraSystemBuilderCmds = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';

    stateVersion = "23.11";
  };

  # Use symlink to the latest nixpkgs of the flake as nixpkgs, e.g. for nix-shell
  nix.nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];

  # https://rycee.gitlab.io/home-manager/options.html
  # https://nix-community.github.io/home-manager/options.html#opt-home.file
  home-manager.users.omega = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "23.11";
  };
}
