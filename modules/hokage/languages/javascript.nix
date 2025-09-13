{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) useInternalInfrastructure;
  cfg = hokage.languages.javascript;

  inherit (lib)
    mkEnableOption
    mkDefault
    ;
in
{
  options.hokage.languages.javascript = {
    enable = mkEnableOption "Enable Javascript development support" // {
      default = hokage.role == "desktop" && useInternalInfrastructure;
    };
    ide.enable = mkEnableOption "Enable Javascript IDE" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      # Set some fish shell aliases
      programs.fish.shellAliases = {
        n18 = "nix-shell /home/${_userName}/.shells/node18.nix --run fish";
      };
    });

    environment.systemPackages = with pkgs; [ nodePackages.nodejs ];

    hokage = {
      jetbrains.phpstorm.enable = mkDefault cfg.ide.enable;
    };
  };
}
