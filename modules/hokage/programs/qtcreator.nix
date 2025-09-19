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
    ;
in
{
  options.hokage.programs.qtcreator = {
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
    });
  };
}
