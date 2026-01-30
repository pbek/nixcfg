# Livingroom PC

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  ...
}:
{
  imports = [
    ./disk-config.zfs.nix
  ];

  # Getting the bootloader to detect Windows didn't work, use F12 at boot for a boot manager
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.device = "nodev";
  # boot.loader.grub.useOSProber = true;
  # boot.loader.grub.extraEntries = ''
  #   menuentry "Windows 10" {
  #     chainloader (hd0,gpt2)+1
  #   }
  # '';

  networking = {
    hosts = {
      "192.168.1.110" = [
        "cicinas"
        "cicinas.lan"
      ];
      "192.168.1.111" = [
        "cicinas2"
        "cicinas2.lan"
      ];
    };

    firewall = {
      allowedTCPPorts = [ 3389 ]; # RDP
    };
  };

  environment.systemPackages = with pkgs; [
    calibre
    zoom-us
    (blender.override { rocmSupport = true; }) # Blender with HIP support for AMD GPUs
    # Temporarily disabled for: sip-4.19.25 not supported for interpreter python3.12
    # Using stable.blender-hip doesn't work because of: Cannot mix incompatible Qt library (5.15.15) with this library (5.15.14)
    #     cura
    # Taken from https://github.com/nix-community/nur-combined/blob/master/repos/xeals/pkgs/by-name/cu/cura5/package.nix
    #    (pkgs.callPackage ../../pkgs/cura5/package.nix { })
    cura-appimage
    amdgpu_top # AMD GPU monitoring
    vlc
    discord
    mycrypto # Cryptocurrency wallet manager
    lm_sensors

    # qtwebengine-5.15.19 is marked insecure
    # jellyfin-media-player
  ];

  # Enable hardware accelerated graphics drivers
  hardware.graphics.enable = true;

  # https://wiki.nixos.org/wiki/AMD_GPU
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  # AMD GPU kernel parameters to fix suspend/resume issues
  # - amdgpu.gpu_recovery=1: Enable GPU recovery mechanisms
  # - amdgpu.ppfeaturemask=0xffffffff: Enable all PowerPlay features
  # - amdgpu.runpm=0: Disable runtime power management to prevent GPU hang on resume
  boot.kernelParams = [
    # "amdgpu.gpu_recovery=1" # Enable GPU recovery mechanisms
    # "amdgpu.ppfeaturemask=0xffffffff"  # Enable all PowerPlay features
    # "amdgpu.runpm=0"                   # Disable runtime power management
    # "amdgpu.preserve_vram=1" # Preserve VRAM contents across suspend/resume

    # "mem_sleep_default=deep" # keep S3
    # "amdgpu.gpu_recovery=1" # reset GPU on hang
    # "amdgpu.dcdebugmask=0x10" # avoid DC deep power gating bugs
    # "amdgpu.reset_method=1" # optional, aggressive GPU reset
  ];

  # Try amdvlk for Dragon Dogma 2
  # See: https://www.protondb.com/app/2054970
  #  hardware.amdgpu.amdvlk = {
  #    enable = true;
  #    support32Bit.enable = true;
  #  };

  # https://wiki.nixos.org/wiki/AMD_GPU#AMDVLK
  #  hardware.opengl.extraPackages = with pkgs; [
  #    amdvlk
  #  ];
  #  # For 32 bit applications
  #  hardware.opengl.extraPackages32 = with pkgs; [
  #    driversi686Linux.amdvlk
  #  ];

  services.ollama = {
    # Turn off because hipblaslt build goes OOM
    enable = false;
    package = pkgs.ollama-rocm;
    #    environmentVariables = {
    #      HCC_AMDGPU_TARGET = "gfx1100"; # used to be necessary, but doesn't seem to anymore
    #    };
    rocmOverrideGfx = "11.0.0";
  };

  # Sleep doesn't work anymore, the fans just go to max speed instead of suspending
  # So disable bluetooth before suspend to see if that helps
  powerManagement.powerDownCommands = ''
    rfkill block bluetooth
  '';

  # AMD GPU recovery after resume - restart display manager to recover from GL context loss
  # The amdgpu driver fails to properly restore the GL context causing KWin to crash
  #  powerManagement.resumeCommands = ''
  #    # Wait a moment for the GPU to stabilize
  #    sleep 2
  #    # Restart the display manager to recover from GL context loss
  #    systemctl restart display-manager
  #  '';

  #  # Enable suspend to RAM
  #  # Sleep is hindered by a component on the motherboard
  #  # Problem with "00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge"
  #  powerManagement.powerUpCommands = ''
  #    echo GPP0 > /proc/acpi/wakeup
  #  '';
  #  # powerManagement.powerDownCommands = ''
  #  #   echo GPP0 > /proc/acpi/wakeup
  #  # '';

  # Restart network and docker after suspend
  # I had issues with KDE Plasma detecting that there is network after suspend
  # But trying to restart it after resume didn't help, so I disabled it
  # powerManagement.resumeCommands = ''
  #   nmcli n off
  #   nmcli n on
  #   systemctl restart docker
  # '';

  # Sleep is hindered by a component on the motherboard
  # Problem with "00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge"
  # Disabling wake-up triggers for all PCIe devices
  # https://wiki.nixos.org/wiki/Power_Management#Solution_1:_Disabling_wakeup_triggers_for_all_PCIe_devices
  # 2nd line: https://github.com/NixOS/nixos-hardware/blob/master/gigabyte/b550/b550-fix-suspend.nix
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1022", ATTR{device}=="0x1483", ATTR{power/wakeup}="disabled"
  '';

  # Make the console font bigger
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u20n.psf.gz";

  # Increase the console font size for kmscon
  services.kmscon.extraConfig = "font-size = 26";

  # AMD GPU monitoring tools
  services.lact.enable = true;

  #  programs.alvr.enable = true;
  #  programs.alvr.openFirewall = true;

  # We have enough RAM
  zramSwap.enable = false;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.steam.gamescopeSession.enable = true; # Integrates with programs.steam

  hokage = {
    hostName = "venus";
    role = "desktop";
    programs = {
      aider.enable = true;
      zerobyte = {
        enable = true;
        useLocalPath = false;
        backupPaths = [
          "/var/lib/docker/volumes"
          "/home"
          "/etc"
          "/root"
          "/mnt/data02/Linux"
        ];
      };
    };
    gaming = {
      enable = true;
      ryubing.highDpi = true;
    };
    zfs = {
      enable = true;
      hostId = "dcdaca04";
      datasetRootName = "root";
    };
    cache.sources = [ "home" ];
  };
}
