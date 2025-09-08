{
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.libvirt;

  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
in
{
  options.hokage.libvirt = {
    enable = mkEnableOption "Enable libvirt support" // {
      default = hokage.role == "desktop";
    };
    gui.enable = mkEnableOption "Enable VirtManager" // {
      default = cfg.role == "host" && hokage.role == "desktop";
    };
    role = mkOption {
      type = types.enum [
        "host"
        "guest"
      ];
      default = "host";
      description = "Role of the libvirt system";
    };
  };

  # https://wiki.nixos.org/wiki/Virt-manager
  config = lib.mkIf cfg.enable {
    #
    # Host configuration
    #
    virtualisation.libvirtd.enable = mkIf (cfg.role == "host") true;
    programs.dconf.enable = mkIf (cfg.role == "host") true;
    programs.virt-manager.enable = mkIf cfg.gui.enable true;
    virtualisation.spiceUSBRedirection.enable = mkIf (cfg.role == "host") true;

    users.users = mkIf (cfg.role == "host") (
      lib.genAttrs hokage.users (_userName: {
        extraGroups = [ "libvirtd" ];
      })
    );

    #
    # Guest configuration
    #
    services.qemuGuest.enable = mkIf (cfg.role == "guest") true;
    # Enable copy and paste between host and guest
    services.spice-vdagentd.enable = mkIf (cfg.role == "guest") true;
  };
}
