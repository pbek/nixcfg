{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) useInternalInfrastructure;
  cfg = hokage.languages.cplusplus;

  inherit (lib)
    mkEnableOption
    mkDefault
    ;
in
{
  options.hokage.languages.cplusplus = {
    enable = mkEnableOption "Enable C++ development support" // {
      default = hokage.role == "desktop" && useInternalInfrastructure;
    };
    qt6.enable = mkEnableOption "Enable Qt6 for IDEs" // {
      default = true;
    };
    ide.enable = mkEnableOption "Enable C++ IDEs" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      # Set some fish shell aliases
      programs.fish.shellAliases = {
        qmake5-path = "nix-shell /home/${_userName}/.shells/qt5.nix --run \"whereis qmake\"";
        qmake6-path = "nix-shell /home/${_userName}/.shells/qt6.nix --run \"whereis qmake\"";
      };
    });

    environment.systemPackages =
      with pkgs;
      [
        cmakeWithGui
        aspell
      ]
      ++ (
        if cfg.qt6.enable then
          [
            qt6.qtbase
            qt6.qttools
            qt6.wrapQtAppsHook
            qt6.qtwebsockets
            qt6.qtdeclarative
            qt6.qtsvg
            qt6.qt5compat
            kdePackages.kwidgetsaddons
            kdePackages.kcompletion
            kdePackages.kcoreaddons
            kdePackages.kconfig
            kdePackages.kio
            kdePackages.kxmlgui
            kdePackages.kiconthemes
            kdePackages.knotifications
            pkg-config
            libgit2
          ]
        else
          [
            cmakeWithGui
            qmake
            qttools
            qtbase
            qtdeclarative
            qtsvg
            qtwayland
            qtwebsockets
            qtx11extras
            wrapQtAppsHook
          ]
      );

    hokage = {
      jetbrains.clion.enable = mkDefault cfg.ide.enable;
      qtcreator.enable = mkDefault cfg.ide.enable;
    };
  };
}
