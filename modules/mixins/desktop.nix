{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
#  cfg = config.services.hokage;
  waylandSupport = config.services.hokage.waylandSupport;
#  usePlasma6 = config.services.hokage.usePlasma6;
#  useEspanso = config.services.hokage.useEspanso;
#  userLogin = config.services.hokage.userLogin;
#  useEspansoPlasma6 = usePlasma6 && useEspanso;

#  waylandSupport = true;
#  usePlasma6 = true;
in
{
  imports = []
#    lib.optional (!waylandSupport && usePlasma6) ./desktop-x11.nix
#    ++ lib.optional (waylandSupport && usePlasma6) ./desktop-wayland.nix
#    ++ lib.optional (!waylandSupport && !usePlasma6) ./desktop-x11-plasma5.nix
    ++ [
      # Other imports here
      ./desktop-common.nix
    ];

#  environment.systemPackages = [] ++ lib.optional (!waylandSupport) [ pkgs.xorg.xkill ];

#  boot.kernelModules = if useEspansoPlasma6 then [ "uinput" ] else [];
#
#  services.udev.extraRules = if useEspansoPlasma6 then ''
#    KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput", GROUP="input", MODE="0660"
#  '' else "";
#
#  home-manager.users.${userLogin} = if useEspansoPlasma6 then {
#    services.espanso = {
#      package = if waylandSupport then pkgs.espanso-wayland else pkgs.espanso;
#      #      package = (pkgs.callPackage ../../apps/espanso/espanso.nix { }).override {
#      #        inherit waylandSupport;
#      #      };
#    };
#  } else {};

#  config = lib.mkMerge [
#    (lib.mkIf cfg.usePlasma6 {
#      services.displayManager.defaultSession = "plasma";
#    })
#
#    (lib.mkIf useEspansoPlasma6 {
#      services.udev.extraRules = ''
#        KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput", GROUP="input", MODE="0660"
#      '';
#    })
#  ];
}
