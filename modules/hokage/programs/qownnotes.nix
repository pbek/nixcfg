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
  mkCatppuccinTheme =
    catppuccinCfg:
    let
      palette =
        (lib.importJSON "${catppuccinCfg.sources.palette}/palette.json").${catppuccinCfg.flavor}.colors;
    in
    {
      background = palette.base.hex;
      foreground = palette.text.hex;
      muted = palette.overlay1.hex;
      accent = palette.${catppuccinCfg.accent}.hex;
      accent_foreground = if catppuccinCfg.flavor == "latte" then palette.text.hex else palette.base.hex;
      success = palette.green.hex;
      warning = palette.yellow.hex;
      error = palette.red.hex;
      heading = palette.${catppuccinCfg.accent}.hex;
      quote = palette.subtext0.hex;
      code = palette.green.hex;
      link = palette.blue.hex;
      fence = palette.overlay0.hex;
      field_background = palette.surface0.hex;
    };

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

    home-manager.users = lib.genAttrs hokage.users (
      _userName:
      { config, ... }:
      let
        catppuccinCfg = config.catppuccin;
      in
      {
        home.file.".config/PBE/QOwnNotes.override.conf" = lib.mkIf hokage.useInternalInfrastructure {
          text = lib.generators.toINI { } cfg.settings;
        };
        xdg.configFile."qownnotes-tui/theme.toml" =
          lib.mkIf (cfg.enableTui && catppuccinCfg.enable && catppuccinCfg.autoEnable)
            {
              source = (pkgs.formats.toml { }).generate "qownnotes-tui-theme.toml" (
                mkCatppuccinTheme catppuccinCfg
              );
            };
        programs.fish.shellAliases = lib.mkIf cfg.enableTui {
          qon = "qownnotes-tui";
        };
      }
    );
  };
}
