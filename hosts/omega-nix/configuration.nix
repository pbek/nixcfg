# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.kernel.sysctl = {
    # Note that inotify watches consume 1kB on 64-bit machines.
    "fs.inotify.max_user_watches" = 1048576; # default: 8192
    "fs.inotify.max_user_instances" = 1024; # default: 128
    "fs.inotify.max_queued_events" = 32768; # default: 16384
  };

  # Enable grub cryptodisk
  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-800753af-5100-407e-b720-4a63512a1d75".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "omega-nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.omega = {
    isNormalUser = true;
    description = "omega";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

#   let
#     unstableTarball =
#       fetchTarball
#         https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
#   in
#   {
#     imports =
#       [ # Include the results of the hardware scan.
#         /etc/nixos/hardware-configuration.nix
#       ];
#
#     nixpkgs.config = {
#       packageOverrides = pkgs: {
#         unstable = import unstableTarball {
#           config = config.nixpkgs.config;
#         };
#       };
#     };
#   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    kate
    kmail
    # smartgithg
    fish
    magic-wormhole
    libsForQt5.yakuake
    xclip
    tmux
    nmap
    git
    jq
    fzf
    chromium
    topgrade
    jetbrains.phpstorm
  ];

#  let
#    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
#  in {
#    environment.systemPackages = with pkgs; [
#      qownnotes
#    ];
#  }

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    openFirewall = lib.mkForce true;
    permitRootLogin = lib.mkForce "no";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

# let
#   unstableTarball =
#     fetchTarball
#       https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
# in
# {
#   imports =
#     [ # Include the results of the hardware scan.
#       ./hardware-configuration.nix
#     ];
#   nixpkgs.config = {
#     packageOverrides = pkgs: with pkgs; {
#       unstable = import unstableTarball {
#         config = config.nixpkgs.config;
#       };
#     };
#   };
#   environment.systemPackages = with pkgs; [
#     unstable.neovim
#     emacs
#   ];
# }
