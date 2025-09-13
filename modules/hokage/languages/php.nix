{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) useInternalInfrastructure;
  cfg = hokage.languages.php;

  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.hokage.languages.php = {
    enable = mkEnableOption "Enable PHP development support" // {
      default = hokage.role == "desktop" && useInternalInfrastructure;
    };
    ide.enable = mkEnableOption "Enable PHP IDE" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      # Set some fish shell aliases
      programs.fish.shellAliases = {
        p8 = "nix-shell /home/${_userName}/.shells/php8.nix --run fish";
      };
    });

    environment.systemPackages = with pkgs; [
      php84
      php84Packages.composer
    ];

    hokage = mkIf cfg.ide.enable {
      jetbrains.enable = true;
      jetbrains.phpstorm.enable = true;
    };
  };
}
