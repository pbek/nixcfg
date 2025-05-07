# Gaia Office Work PC

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  ...
}:
let
  inherit (config.hokage) userLogin;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/mixins/users.nix
    ../../modules/mixins/desktop.nix
    ../../modules/mixins/audio.nix
    ../../modules/mixins/platformio.nix
    ../../modules/mixins/openssh.nix
    ../../modules/mixins/virt-manager.nix
    ../../modules/mixins/local-store-cache.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "gaia"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  services.avahi.nssmdns4 = true;
  # Samsung printer driver for ML-1710
  services.printing.drivers = [ pkgs.splix ];

  environment.systemPackages = with pkgs; [
    calibre
    arduino-ide
    g810-led # Logitech G213 keyboard
    kdePackages.kdialog
    bitscope.meter
    bitscope.dso
    bitscope.logic
    #    (pkgs.callPackage ../../pkgs/bitscope/packages.nix { }).meter
    #    (pkgs.callPackage ../../pkgs/bitscope/packages.nix { }).dso
    #    (pkgs.callPackage ../../pkgs/bitscope/packages.nix { }).logic
    blender
    # Temporarily disabled for: sip-4.19.25 not supported for interpreter python3.12
    # Using stable.blender-hip doesn't work because of: Cannot mix incompatible Qt library (5.15.15) with this library (5.15.14)
    #    cura
    # Taken from https://github.com/nix-community/nur-combined/blob/master/repos/xeals/pkgs/by-name/cu/cura5/package.nix
    #    (pkgs.callPackage ../../pkgs/cura5/package.nix { })
    cura-appimage
    #    (pkgs.callPackage ../../pkgs/lact/package.nix { })
    lact
  ];

  # Handle keyboard leds
  powerManagement.powerUpCommands = ''
    ${pkgs.g810-led}/bin/g213-led -r 1 ff0000     # Set color of zone 1 to red
    ${pkgs.g810-led}/bin/g213-led -r 2 ff0000     # Set color of zone 2 to red
    ${pkgs.g810-led}/bin/g213-led -r 3 ff0000     # Set color of zone 3 to red
    ${pkgs.g810-led}/bin/g213-led -r 4 7fff00     # Set color of zone 4 to green
    ${pkgs.g810-led}/bin/g213-led -r 5 7fff00     # Set color of zone 5 to green
  '';

  # Extract

  # https://github.com/NixOS/nixpkgs/issues/215450
  # users.users.${userLogin} = {
  #   packages = with pkgs; [
  #     playwright
  #     (runCommand "wrapped-playwright" { buildInputs = [ makeWrapper ]; } ''
  #     mkdir -p "$out/bin"
  #     makeWrapper "${playwright}/bin/playwright" "$out/bin/playwright" \
  #       --set PLAYWRIGHT_BROWSERS_PATH "${playwright-driver.browsers}"
  #     '')
  #   ];
  # };

  # https://nixos.wiki/wiki/VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ userLogin ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # Try to get get around: /nix/store/lx50avim6rzf20b69q4zwak07c479qwp-udev-rules/60-openocd.rules:188 Unknown group 'plugdev', ignoring.
  # https://github.com/NixOS/nixpkgs/issues/81326#issuecomment-592790668
  users.users.${userLogin} = {
    extraGroups = [ "plugdev" ];
  };

  # https://nixos.wiki/wiki/steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # https://nixos.wiki/wiki/Linux_kernel
  # linuxPackages_latest: 6.13
  # linuxPackages_lts: 6.6
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Workaround for broken VirtualBox with kernel 6.12
  # https://github.com/NixOS/nixpkgs/issues/363887
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  # https://nixos.wiki/wiki/nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
    # GeForce RTX 2070 SUPER should support open source driver
    # https://github.com/NVIDIA/open-gpu-kernel-modules?tab=readme-ov-file#compatible-gpus
    open = true;

    # production: version 550
    # latest: version 565
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    #    # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
    #    modesetting.enable = true;
  };

  # We have enough RAM
  zramSwap.enable = false;

  # Try to prevent popping of loudspeakers when audio starts again
  # See https://nixos.wiki/wiki/PulseAudio#Disabling_unwanted_modules
  services.pulseaudio.extraConfig = "unload-module module-suspend-on-idle";

  # Increase the console font size for kmscon
  services.kmscon.extraConfig = "font-size = 26";

  hokage = {
    tugraz.enable = true;
    jetbrains = {
      plugins = [ ];
      clion.package = pkgs.jetbrains.clion;
      phpstorm.package = pkgs.jetbrains.phpstorm;
      goland.package = pkgs.jetbrains.goland;
    };
  };
}
