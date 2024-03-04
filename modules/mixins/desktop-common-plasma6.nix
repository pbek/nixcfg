{ config, pkgs, inputs, username, weztermFontSize, ... }:
{
  imports = [
    ./desktop-common.nix
  ];

  services.xserver.desktopManager.plasma6.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kdePackages.kwalletmanager
    kdePackages.plasma-systemmonitor
    kdePackages.kfind
    kdePackages.kontact
    kdePackages.akonadiconsole
    kdePackages.kleopatra
    kdePackages.kmail
    kdePackages.korganizer
    kdePackages.kaddressbook
    kdePackages.yakuake
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.bluedevil
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.gwenview
    kdePackages.kaccounts-integration
    kdePackages.kaccounts-providers
    kdePackages.ksshaskpass
    kdePackages.okular
    kdePackages.plasma-browser-integration
    kdePackages.plasma-disks
    kdePackages.plasma-nm
    kdePackages.plasma-pa
    kdePackages.plasma-vault

    # Add missing dependency for espanso
    wl-clipboard
  ];

  # Get around: [ERROR] Error: could not open uinput device
  boot.kernelModules = [ "uinput" ];

  # Get around permission denied error on /dev/uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput", GROUP="input", MODE="0660"
  '';

  home-manager.users.${username} = {
    # https://mynixos.com/home-manager/options/services.espanso
    services.espanso = {
      package = (pkgs.callPackage ../../apps/espanso/espanso.nix { });
    };
  };
}
