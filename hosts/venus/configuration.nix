# Livingroom PC

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  ...
}:
let
  userLogin = config.services.hokage.userLogin;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/mixins/users.nix
    #      ../../modules/mixins/desktop-x11.nix
    ../../modules/mixins/desktop.nix
    ../../modules/mixins/audio.nix
    ../../modules/mixins/jetbrains.nix
    ../../modules/mixins/openssh.nix
    ../../modules/mixins/virt-manager.nix
    ../../modules/mixins/local-store-cache.nix
    #      ../../modules/mixins/remote-store-cache.nix
  ];

  # Bootloader
  # Getting the bootloader to detect Windows didn't work, use F12 at boot for a boot manager
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.device = "nodev";
  # boot.loader.grub.useOSProber = true;
  # boot.loader.grub.extraEntries = ''
  #   menuentry "Windows 10" {
  #     chainloader (hd0,gpt2)+1
  #   }
  # '';

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "venus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  networking.hosts = {
    "192.168.1.110" = [
      "cicinas"
      "cicinas.lan"
    ];
    "192.168.1.111" = [
      "cicinas2"
      "cicinas2.lan"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [ 3389 ]; # RDP
  };

  environment.systemPackages = with pkgs; [
    calibre
    zoom-us
    stable.blender-hip # Blender with HIP support for AMD GPUs
    # Temporarily disabled for: sip-4.19.25 not supported for interpreter python3.12
    # Using stable.blender-hip doesn't work because of: Cannot mix incompatible Qt library (5.15.15) with this library (5.15.14)
    #     cura
    # Taken from https://github.com/nix-community/nur-combined/blob/master/repos/xeals/pkgs/by-name/cu/cura5/package.nix
    (pkgs.callPackage ../../apps/cura5/package.nix { })
    wowup-cf
    #    (pkgs.callPackage ../../apps/wowup-cf/default.nix { })
    heroic # Epic Games Store
    amdgpu_top # AMD GPU monitoring
    lact # AMD GPU monitoring
  ];

  # https://nixos.wiki/wiki/steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    protontricks.enable = true; # Protontricks is a simple wrapper that does winetricks things for Proton enabled games
  };

  # Try to use the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable hardware accelerated graphics drivers
  hardware.graphics.enable = true;

  # https://nixos.wiki/wiki/AMD_GPU
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Try amdvlk for Dragon Dogma 2
  # See: https://www.protondb.com/app/2054970
  #  hardware.amdgpu.amdvlk = {
  #    enable = true;
  #    support32Bit.enable = true;
  #  };

  # https://nixos.wiki/wiki/AMD_GPU#AMDVLK
  #  hardware.opengl.extraPackages = with pkgs; [
  #    amdvlk
  #  ];
  #  # For 32 bit applications
  #  hardware.opengl.extraPackages32 = with pkgs; [
  #    driversi686Linux.amdvlk
  #  ];

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    package = pkgs.stable.ollama;
    #    environmentVariables = {
    #      HCC_AMDGPU_TARGET = "gfx1100"; # used to be necessary, but doesn't seem to anymore
    #    };
    rocmOverrideGfx = "11.0.0";
  };

  #  # Enable suspend to RAM
  #  # Sleep is hindered by a compontent on the motherboard
  #  # Problem with "00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge"
  #  powerManagement.powerUpCommands = ''
  #    echo GPP0 > /proc/acpi/wakeup
  #  '';
  #  # powerManagement.powerDownCommands = ''
  #  #   echo GPP0 > /proc/acpi/wakeup
  #  # '';

  # Restart network and docker after suspend
  # I had issues with KDE Plasma detecting that there is network after suspend
  powerManagement.resumeCommands = ''
    nmcli n off
    nmcli n on
    systemctl restart docker
  '';

  # Sleep is hindered by a compontent on the motherboard
  # Problem with "00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge"
  # Disabling wakeup triggers for all PCIe devices
  # https://nixos.wiki/wiki/Power_Management#Solution_1:_Disabling_wakeup_triggers_for_all_PCIe_devices
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  '';

  # Make the console font bigger
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u20n.psf.gz";

  # https://nixos.wiki/wiki/VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ userLogin ];

  programs.alvr.enable = true;
  programs.alvr.openFirewall = true;

  # We have enough RAM
  zramSwap.enable = false;
}
