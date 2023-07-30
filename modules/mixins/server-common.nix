{ config, pkgs, inputs, lib, ... }:
{
  imports = [
  ];

  # https://mynixos.com/options/services.openssh
  services.openssh = {
    enable = true;
    openFirewall = lib.mkForce true;

    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = lib.mkForce "no";
  };

  # https://nixos.wiki/wiki/Fail2ban
  services.fail2ban.enable = true;

  # Set some fish config
  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      ll = "ls -hal";
    };
  };

  programs.bash.shellAliases = config.programs.fish.shellAliases;

  # Define a user account. Don't forget to set a password with ?passwd?.
  users.users.omega = {
    isNormalUser = true;
    description = "Patrizio Bekerle";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" ];
    shell = pkgs.fish;
    # Yubikey public key
    openssh.authorizedKeys.keys = ["sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@i7work"];
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

  # Firewall
  # https://nixos.wiki/wiki/Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSH
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      # Allow flakes
      experimental-features = [ "nix-command" "flakes" ];

      # To do a "nix-build --repair" without sudo
      trusted-users = [ "root" "@wheel" ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.x86_64-linux.default
    neovim
    wget
    fish
    fishPlugins.fzf-fish
    tmux
    git
    jq
    fzf
    less
    mc
    htop
    atop
    btop
    inetutils
    dig
    gnumake
    ncdu
    duf
    ranger
    rsync
    restic
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
    owner = "omega";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  # Docker
  # https://nixos.wiki/wiki/Docker
  virtualisation.docker.enable = true;

  # https://rycee.gitlab.io/home-manager/options.html
  home-manager.users.omega = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "23.05";

    # https://rycee.gitlab.io/home-manager/options.html
    # enable starship prompt in fish shell, enableFishIntegration in the starship config did not work
    home.file.".config/fish/conf.d/starship.fish".text = ''
      starship init fish | source
    '';

    # Enable starship for bash
    home.file.".bash_aliases".text = ''
      eval "$(starship init bash)"
    '';

    # enable https://starship.rs
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      # https://starship.rs/config
      settings = {
        # add_newline = false;
        directory = {
          fish_style_pwd_dir_length = 3; # The number of characters to use when applying fish shell pwd path logic.
          truncation_length = 1; # The number of parent folders that the current directory should be truncated to.
        };
        username = {
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
        };
        # https://starship.rs/config/#shell
        shell = {
          disabled = false;
          fish_indicator = "󰈺";
          # bash_indicator = "b";
        };
        status.disabled = false;

        # Move the directory to the second line
        # https://starship.rs/config/#default-prompt-format
        format = "$all$directory$status$character";

        # format = "$username$hostname$localip$shlvl$singularity$kubernetes$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$swift$terraform$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$battery$time$status$os$container$shell$directory$character";
      };
    };
  };
}
