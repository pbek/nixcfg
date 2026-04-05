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
  opencodeThemeName =
    if hokage.catppuccin.flavor == "frappe" then
      "catppuccin-frappe"
    else if hokage.catppuccin.flavor == "macchiato" then
      "catppuccin-macchiato"
    else
      "catppuccin";
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
      catppuccin.opencode.enable = false;

      programs = {
        # https://github.com/anomalyco/opencode
        # Use "/connect" to connect to GitHub Copilot or Azure OpenAI
        opencode = {
          enable = true;
          enableMcpIntegration = true;
          settings = {
            provider = {
              "azure-anthropic" = {
                name = "Azure AI Foundry (Anthropic)";
                npm = "@ai-sdk/anthropic";
                api = "https://{env:AZURE_RESOURCE_NAME}.services.ai.azure.com/anthropic/v1";
                models = {
                  "claude-opus-4-6" = {
                    id = "claude-opus-4-6";
                    name = "Claude Opus 4.6";
                    tool_call = true;
                    attachment = true;
                    reasoning = true;
                    temperature = true;
                  };
                  "claude-sonnet-4-6" = {
                    id = "claude-sonnet-4-6";
                    name = "Claude Sonnet 4.6";
                    tool_call = true;
                    attachment = true;
                    reasoning = true;
                    temperature = true;
                  };
                };
              };
            };
          };
          tui = lib.optionalAttrs hokage.catppuccin.enable {
            theme = opencodeThemeName;
          };
        };
      };
    });
  };
}
