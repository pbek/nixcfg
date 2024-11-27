{
  config,
  pkgs,
  inputs,
  userLogin,
  x11Support,
  waylandSupport,
  ...
}:
{
  # Get around: [ERROR] Error: could not open uinput device
  boot.kernelModules = [ "uinput" ];

  # Get around permission denied error on /dev/uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput", GROUP="input", MODE="0660"
  '';

  home-manager.users.${userLogin} = {
    # https://mynixos.com/home-manager/options/services.espanso
    services.espanso = {
      package = if waylandSupport then pkgs.espanso-wayland else pkgs.espanso;
      #      package = (pkgs.callPackage ../../apps/espanso/espanso.nix { }).override {
      #        inherit x11Support;
      #        inherit waylandSupport;
      #      };
    };
  };
}
