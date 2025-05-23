{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.virtManager;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.virtManager = {
    enable = mkEnableOption "Enable VirtManager support" // {
      default = hokage.role == "desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://wiki.nixos.org/wiki/Virt-manager
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ virt-manager ];
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
