{
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.gemini-cli;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.programs.gemini-cli = {
    enable = mkEnableOption "Google Gemini CLI" // {
      default = hokage.role == "desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      programs = {
        # https://github.com/google-gemini/gemini-cli
        gemini-cli = {
          enable = true;
          settings = {
            security.auth.selectedType = "oauth-personal";
          };
        };
      };
    });
  };
}
