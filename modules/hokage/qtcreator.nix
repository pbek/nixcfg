{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) useInternalInfrastructure;
  cfg = hokage.qtcreator;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.qtcreator = {
    enable = mkEnableOption "Enable qtcreator" // {
      default = hokage.role == "desktop" && useInternalInfrastructure;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qtcreator
    ];

    home-manager.users = lib.genAttrs hokage.users (_userName: {
      programs.fish.shellAliases = {
        qtc = "nix-shell /home/${_userName}/.shells/qt5.nix --run qtcreator";
        qtc6 = "nix-shell /home/${_userName}/.shells/qt6.nix --run qtcreator";
      };

      xdg.desktopEntries = {
        qtcreator-nix-shell = {
          name = "Qt Creator with dev packages";
          genericName = "C++ IDE for developing Qt applications";
          comment = "";
          icon = "${pkgs.qtcreator}/share/icons/hicolor/128x128/apps/QtProject-qtcreator.png";
          exec = "nix-shell /home/${_userName}/.shells/qt5.nix --run qtcreator";
          terminal = false;
          categories = [ "Development" ];
        };
      };
    });
  };
}
