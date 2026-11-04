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
in
{
  options.hokage.programs.hex = {
    enable = lib.mkEnableOption "Hex local voice dictation" // {
      default = hokage.role == "desktop";
      defaultText = lib.literalExpression ''config.hokage.role == "desktop"'';
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      imports = [ inputs.hex.homeManagerModules.default ];

      programs.hex = {
        enable = true;
        # Module consumers may not apply the root flake's package overlays.
        package = pkgs.hex-dictation or (pkgs.callPackage "${inputs.hex}/nix/package.nix" { });
        settings = {
          # Equivalent to `hex labs on special-keys`.
          "labs.standalone_special_keys" = lib.mkDefault true;
          dictation_hotkey = lib.mkDefault "scrolllock";
        };
      };
    });
  };
}
