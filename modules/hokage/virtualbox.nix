{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userLogin;
  cfg = hokage.virtualbox;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.virtualbox = {
    enable = mkEnableOption "Enable VirtualBox";
    maxKernelVersion = lib.mkOption {
      type = lib.types.package;
      default = pkgs.linuxKernel.packages.linux_6_14.kernel;
      description = "Maximum allowed kernel package vor VirtualBox";
      readOnly = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # https://wiki.nixos.org/wiki/VirtualBox
    virtualisation.virtualbox = {
      host.enable = true;
      guest = {
        enable = true;
        dragAndDrop = true;
      };
    };

    users.extraGroups.vboxusers.members = [ userLogin ];

    # Use the latest kernel version working with VirtualBox
    hokage.kernel.requirements = [ cfg.maxKernelVersion ];

    # Workaround for broken VirtualBox with Kernel 6.12+
    # https://github.com/NixOS/nixpkgs/issues/363887
    boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
  };
}
