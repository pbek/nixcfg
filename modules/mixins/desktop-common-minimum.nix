{
  config,
  pkgs,
  inputs,
  userLogin,
  termFontSize,
  ...
}:
{
  imports = [
    ./common.nix
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
  services.displayManager.sddm.enable = true;
  programs.kdeconnect.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Firewall
  # https://nixos.wiki/wiki/Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedTCPPorts = [ 22 ]; # SSH
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  environment.systemPackages = with pkgs; [
    attic-client
    inputs.agenix.packages.x86_64-linux.default
    firefox
    stable.magic-wormhole
    xclip
    fzf
    fishPlugins.fzf-fish
    usbutils # lsusb

    #    qownnotes
    (pkgs.qt6Packages.callPackage ../../apps/qownnotes/default.nix { })
    qc
    #    (pkgs.callPackage ../../apps/qc/default.nix { })
    bluez
    nextcloud-client
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # You seem to need to set the default pinentry, otherwise there is a conflict
    # Try to use pinentry-qt to be able to enter the password in kmail
    pinentryPackage = pkgs.pinentry-qt;
  };

  # Enable Fwupd
  # https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  # Enable Netbird Wireguard VPN service
  services.netbird.enable = true;

  users.users.${userLogin} = {
    openssh.authorizedKeys.keys = [
      # Yubikey public key
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@yubikey"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3ySO2ND+Za5z67zWrqMONDXLKBDgOKGuGRXJ2fNKfeN84lPkok/YTNifzvKAFWLB8tvzdQITUV2AaTWt7F33iJpfmJBG1OO2tgsr9SLUpwgthWMrA4FwsFI5/jhw4gQAa5i6R7nkKxOjaXe7BoS82OyIpIhXXpm5TDzMwWelJUBPhYxcDvoZD2BU0SVW3/uFBYIlHsQ5nNyoNtkDf6iJGRF6MlreAI2gyJMcnOm/DxhJ8l1D7BFZ1rPncDCOCn8YnFykp/R58VJBX2dosFaZQr7/17+exDivB4kPlpmWQS74Xej16QsHaqxocS/s0Vj5uQdI8Hk4fLum4yFf5Rxk7 omega@rsa"
    ];
  };

  # https://rycee.gitlab.io/home-manager/options.html
  # https://nix-community.github.io/home-manager/options.html#opt-home.file
  home-manager.users.${userLogin} = {
    # allow unfree packages in nix-shell
    home.file.".config/nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
      }
    '';

    # Set up "shells" directory (e.g. for JetBrains IDEs and QtCreator)
    home.file.".shells" = {
      source = ../../files/shells;
    };

    # KDE Plasma 5
    home.file.".local/share/kservices5" = {
      source = ../../files/kservices5;
    };

    # KDE Plasma 6
    home.file.".local/share/kio/servicemenus" = {
      source = ../../files/kservices5;
    };

    # Add config for zellij
    home.file.".config/zellij" = {
      source = ../../files/zellij;
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

  # KDE partition-manager doesn't work when installed directly
  programs.partition-manager.enable = true;

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
