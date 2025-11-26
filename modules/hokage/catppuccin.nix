{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.hokage.catppuccin;
  inherit (config) hokage;
in
{
  options.hokage.catppuccin = {
    enable = lib.mkEnableOption "Catppuccin theme" // {
      default = true;
    };
    flavor = lib.mkOption {
      type = lib.types.enum [
        "latte"
        "frappe"
        "macchiato"
        "mocha"
      ];
      default = "mocha";
      description = "Catppuccin flavor to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.usersWithRoot (_userName: {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      # https://nix.catppuccin.com/options/main/nixos
      catppuccin = {
        enable = true;
        flavor = cfg.flavor;
      };
    });
  };
}
