{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) useInternalInfrastructure;
  cfg = hokage.programs.qtcreator;

  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
in
{
  options.hokage.programs.qtcreator = {
    enable = mkEnableOption "qtcreator" // {
      default = hokage.role == "desktop" && useInternalInfrastructure;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.qtcreator;
      description = "The QtCreator package to install";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
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
          icon = "${cfg.package}/share/icons/hicolor/128x128/apps/QtProject-qtcreator.png";
          exec = "nix-shell /home/${_userName}/.shells/qt6.nix --run qtcreator";
          terminal = false;
          categories = [ "Development" ];
        };
      };
    });
  };
}
