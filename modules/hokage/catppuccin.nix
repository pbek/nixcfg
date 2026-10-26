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
    home-manager.users = lib.genAttrs hokage.usersWithRoot (
      _userName: { config, ... }: {
        imports = [
          inputs.catppuccin.homeModules.catppuccin
        ];

        # https://nix.catppuccin.com/options/main/home/catppuccin/
        catppuccin = {
          enable = true;
          autoEnable = true;
          inherit (cfg) flavor;
          # The pinned integration still writes tui.json, which OpenCode 2 ignores.
          opencode.enable = false;
        };

        programs.opencode.cli = lib.mkIf config.programs.opencode.enable {
          theme = {
            name =
              if
                builtins.elem config.catppuccin.opencode.flavor [
                  "frappe"
                  "macchiato"
                ]
              then
                "catppuccin-${config.catppuccin.opencode.flavor}"
              else
                "catppuccin";
            mode = if config.catppuccin.opencode.flavor == "latte" then "light" else "dark";
          };
        };
      }
    );
  };
}
