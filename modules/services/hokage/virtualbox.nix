{
  config,
  lib,
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

    # Workaround for broken VirtualBox with Kernel 6.12+
    # https://github.com/NixOS/nixpkgs/issues/363887
    boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
  };
}
