{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.hex;
  qownnotesPhrases = [
    "Q on nodes"
    "Q all nodes"
    "Q All Nods"
    "Q own nodes"
    "Q O nodes"
    "Q all notes"
    "Few own those"
    "Few own nodes"
    "QO node"
  ];
in
{
  options.hokage.programs.hex = {
    enable = lib.mkEnableOption "Hex local voice dictation" // {
      default = hokage.role == "desktop";
      defaultText = lib.literalExpression ''config.hokage.role == "desktop"'';
    };
    shortcut = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "scrolllock";
      description = "Hex dictation shortcut. Leave null to preserve Hex's existing shortcut or application default.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.users (
      _userName: { config, lib, ... }: {
        imports = [ inputs.hex.homeManagerModules.default ];

        programs.hex = {
          enable = true;
          # Module consumers may not apply the root flake's package overlays.
          package = pkgs.hex-dictation or (pkgs.callPackage "${inputs.hex}/nix/package.nix" { });
          settings = {
            # Equivalent to `hex labs on special-keys`.
            "labs.standalone_special_keys" = lib.mkDefault true;
            "dictation_processing.default_mode" = lib.mkDefault {
              name = "Global";
              replacements = map (matched_phrase: {
                inherit matched_phrase;
                output = "QOwnNotes";
              }) qownnotesPhrases;
              post_processing.enabled = false;
              transformations = [ ];
            };
          }
          // lib.optionalAttrs (cfg.shortcut != null) {
            dictation_hotkey = lib.mkDefault cfg.shortcut;
          };
        };

        # The shared vocabulary has its own CLI, not a writable settings key.
        # Adding spellings is idempotent and preserves other vocabulary entries.
        home.activation.hexVocabulary = lib.hm.dag.entryAfter [ "hexSettings" ] ''
          if ! run ${pkgs.coreutils}/bin/env HEX_APPLICATION_SUPPORT_DIR=${lib.escapeShellArg "${config.xdg.dataHome}/hex"} \
            ${lib.getExe config.programs.hex.package} vocabulary add QOwnNotes \
            --sounds-like ${lib.escapeShellArg (lib.concatStringsSep "," qownnotesPhrases)}; then
            warnEcho "Hex didn't add the QOwnNotes vocabulary; see the message above."
          fi
        '';
      }
    );
  };
}
