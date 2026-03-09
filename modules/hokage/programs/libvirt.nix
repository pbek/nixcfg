{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.libvirt;

  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
in
{
  options.hokage.programs.libvirt = {
    enable = mkEnableOption "libvirt support" // {
      default = hokage.role == "desktop";
    };
    gui.enable = mkEnableOption "VirtManager" // {
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

  # https://wiki.nixos.org/wiki/Libvirt
  config = lib.mkIf cfg.enable {
    #
    # Host configuration
    #
    virtualisation.libvirtd = mkIf (cfg.role == "host") {
      enable = true;
      qemu = {
        # Enable TPM emulation (useful for Windows 11)
        swtpm.enable = true;
      };
    };
    programs.dconf.enable = mkIf (cfg.role == "host") true;
    virtualisation.spiceUSBRedirection.enable = mkIf (cfg.role == "host") true;

    # Work around upstream unit using /usr/bin/sh, which does not exist on NixOS.
    systemd.services.virt-secret-init-encryption = mkIf (cfg.role == "host") {
      serviceConfig.ExecStart = lib.mkForce [
        ""
        "${pkgs.runtimeShell} -c \"umask 0077 && ${pkgs.coreutils}/bin/dd if=/dev/random status=none bs=32 count=1 | ${pkgs.systemd}/bin/systemd-creds encrypt --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key\""
      ];
    };

    # https://wiki.nixos.org/wiki/Virt-manager
    programs.virt-manager.enable = mkIf cfg.gui.enable true;

    users.users = mkIf (cfg.role == "host") (
      lib.genAttrs hokage.users (_userName: {
        extraGroups = [ "libvirtd" ];
      })
    );

    # Netcat with -U parameter for libvirt remote access
    environment.systemPackages = mkIf (cfg.role == "host") (with pkgs; [ netcat-openbsd ]);

    #
    # Guest configuration
    #
    services.qemuGuest.enable = mkIf (cfg.role == "guest") true;
    # Enable copy and paste between host and guest
    services.spice-vdagentd.enable = mkIf (cfg.role == "guest") true;
  };
}
