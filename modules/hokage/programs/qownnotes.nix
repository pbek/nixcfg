{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.qownnotes;

  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
in
{
  options.hokage.programs.qownnotes = {
    enable = mkEnableOption "QOwnNotes note-taking app" // {
      default = hokage.role == "desktop" || hokage.role == "ally";
    };
    enableTui = mkEnableOption "QOwnNotes terminal browser" // {
      default = true;
    };
    settings = mkOption {
      type = types.attrsOf (types.attrsOf (types.either types.bool (types.either types.int types.str)));
      default = {
        Editor = {
          hangingIndent = true;
          showLineNumbers = true;
          showMarkdownImagePreviews = true;
        };
      };
      description = "Settings for QOwnNotes.override.conf";
      example = {
        General = {
          darkMode = true;
          interfaceLanguage = "en";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.qownnotes
    ]
    ++
      lib.optional cfg.enableTui
        inputs.qownnotes-tui.packages.${pkgs.stdenv.hostPlatform.system}.default;

    home-manager.users = lib.genAttrs hokage.users (_userName: {
      home.file.".config/PBE/QOwnNotes.override.conf" = lib.mkIf hokage.useInternalInfrastructure {
        text = lib.generators.toINI { } cfg.settings;
      };
      programs.fish.shellAliases = lib.mkIf cfg.enableTui {
        qon = "qownnotes-tui";
      };
    });
  };
}
