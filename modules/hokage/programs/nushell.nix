{
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.nushell;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.programs.nushell = {
    enable = mkEnableOption "Enable Nushell" // {
      default = hokage.role == "desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      programs = {
        # https://www.nushell.sh/book/
        nushell = {
          enable = true;
          inherit (config.programs.fish) shellAliases;
        };

        zoxide.enableNushellIntegration = true;
        direnv.enableNushellIntegration = true;
        eza.enableNushellIntegration = true;
        starship.enableNushellIntegration = config.hokage.programs.starship.enable;
        atuin.enableNushellIntegration = config.hokage.programs.atuin.enable;
        yazi.enableNushellIntegration = config.hokage.programs.yazi.enable;
      };
    });
  };
}
