{
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.opencode;
  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.programs.opencode = {
    enable = mkEnableOption "AI coding agent built for the terminal" // {
      default = hokage.role == "desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    # Set Azure resource name for applications that need it, e.g., opencode
    environment.sessionVariables = {
      AZURE_RESOURCE_NAME = "zid-digitalisation-coding";
    };

    programs.fish.shellAliases = {
      oc = "AZURE_RESOURCE_NAME=zid-digitalisation-coding opencode";
    };

    home-manager.users = lib.genAttrs hokage.users (_userName: {
      programs = {
        # https://github.com/anomalyco/opencode
        # Use "/connect" to connect to GitHub Copilot or Azure OpenAI
        opencode = {
          enable = true;
          enableMcpIntegration = true;
        };
      };
    });
  };
}
