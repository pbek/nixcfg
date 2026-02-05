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
  imports = [ ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.avahi.nssmdns4 = true;
  # Samsung printer driver for ML-1710
  services.printing.drivers = [ pkgs.splix ];

  environment.systemPackages = with pkgs; [
    calibre
    arduino-ide
    g810-led # Logitech G213 keyboard
    kdePackages.kdialog
    #    bitscope.meter
    #    bitscope.dso
    #    bitscope.logic
    (pkgs.callPackage ../../pkgs/bitscope/packages.nix { }).meter
    (pkgs.callPackage ../../pkgs/bitscope/packages.nix { }).dso
    (pkgs.callPackage ../../pkgs/bitscope/packages.nix { }).logic
    blender
    # Temporarily disabled for: sip-4.19.25 not supported for interpreter python3.12
    # Using stable.blender-hip doesn't work because of: Cannot mix incompatible Qt library (5.15.15) with this library (5.15.14)
    #    cura
    # Taken from https://github.com/nix-community/nur-combined/blob/master/repos/xeals/pkgs/by-name/cu/cura5/package.nix
    #    (pkgs.callPackage ../../pkgs/cura5/package.nix { })
    cura-appimage
    #    (pkgs.callPackage ../../pkgs/lact/package.nix { })
    lact
    rustdesk-flutter
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

  # Try to get get around: /nix/store/lx50avim6rzf20b69q4zwak07c479qwp-udev-rules/60-openocd.rules:188 Unknown group 'plugdev', ignoring.
  # https://github.com/NixOS/nixpkgs/issues/81326#issuecomment-592790668
  users.users.${userLogin} = {
    extraGroups = [ "plugdev" ];
  };

  # Add a normal user for testing purposes
  users.users.test = {
    isNormalUser = true;
  };

  # https://wiki.nixos.org/wiki/steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # We have enough RAM
  zramSwap.enable = false;

  # Try to prevent popping of loudspeakers when audio starts again
  # See https://wiki.nixos.org/wiki/PulseAudio#Disabling_unwanted_modules
  services.pulseaudio.extraConfig = "unload-module module-suspend-on-idle";

  # Increase the console font size for kmscon
  services.kmscon.extraConfig = "font-size = 26";

  services.uncrash = {
    enable = true;
  };

  # Try to get around being stuck after resume
  # https://chatgpt.com/c/690d9bc5-e334-832b-b459-86b3e0f9250b
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  hokage = {
    hostName = "gaia";
    tugraz.enable = true;
    cache.sources = [ "home" ];
    programs.platformio.enable = true;
    programs.aider.enable = true;

    nvidia = {
      enable = true;
      packageType = "beta";
      # With kernel 6.17.2 there were no resolutions detected without modesetting
      modesetting.enable = true;
    };
  };
}
