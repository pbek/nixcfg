# macBook

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  ...
}:

let
  broadcomSta = "broadcom-sta-6.30.223.271-63-${config.boot.kernelPackages.kernel.version}";
in

{
  imports = [
    ./disk-config.zfs.nix
  ];

  # blacklist BCM43a0 Broadcom wifi
  # Wifi seems to still work and it seems much more stable
  boot.blacklistedKernelModules = [ "brcm80211" ];

  # Don't sleep when lid is closed
  # services.logind.lidSwitch = "ignore";

  # Allow insecure Broadcom driver
  nixpkgs.config.permittedInsecurePackages = [
    broadcomSta
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_2.extend (
    _final: prev: {
      broadcom_sta = prev.broadcom_sta.overrideAttrs (old: {
        # The module aggregator requires certificates for external modules.
        # Sign after fixup so stripping cannot invalidate the signature.
        postFixup = (old.postFixup or "") + ''
          ${pkgs.buildPackages.kmodigest}/bin/kmodigest \
            "$out/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/kernel/net/wireless/wl.ko"
        '';
      });
    }
  );

  environment.systemPackages = with pkgs; [
    powertop
  ];

  hokage = {
    hostName = "neptun";
    lowBandwidth = true;
    cache.sources = [ "home" ];
    zfs = {
      enable = true;
      hostId = "c15661e7";
      encrypted = true;
    };
    programs.jetbrains.enable = false;
  };
}
