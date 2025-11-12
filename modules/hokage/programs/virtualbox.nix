{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userLogin;
  cfg = hokage.programs.virtualbox;

  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in
{
  options.hokage.programs.virtualbox = {
    enable = mkEnableOption "VirtualBox";
    role = mkOption {
      type = types.enum [
        "host"
        "guest"
      ];
      default = "host";
      description = "Role of the VirtualBox system";
    };
    maxKernelVersion = lib.mkOption {
      type = lib.types.package;
      # Set the currently maximum allowed kernel package for VirtualBox here
      # Look if package is available for your kernel version on https://search.nixos.org/packages?channel=unstable&type=packages&query=linuxKernel.packages.linux_6_17.virtualbox
      default = pkgs.linuxKernel.packages.linux_6_17.kernel;
      description = "Maximum allowed kernel package vor VirtualBox";
      readOnly = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # https://wiki.nixos.org/wiki/VirtualBox
    virtualisation.virtualbox = mkIf (cfg.role == "host") {
      host.enable = true;
      guest = {
        enable = true;
        dragAndDrop = true;
      };
    };

    users.extraGroups.vboxusers.members = mkIf (cfg.role == "host") [ userLogin ];

    # Use the latest kernel version working with VirtualBox
    hokage.kernel.requirements = [ cfg.maxKernelVersion ];

    # Workaround for broken VirtualBox with Kernel 6.12+
    # https://github.com/NixOS/nixpkgs/issues/363887
    boot.kernelParams = mkIf (cfg.role == "host") [ "kvm.enable_virt_at_load=0" ];
  };
}
