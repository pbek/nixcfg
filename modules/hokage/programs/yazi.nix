{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.yazi;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.programs.yazi = {
    enable = mkEnableOption "Yazi terminal file manager" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs hokage.usersWithRoot (_userName: {
      programs = {
        # Blazing fast terminal file manager written in Rust
        # https://github.com/sxyazi/yazi
        yazi = {
          enable = true;
          enableFishIntegration = true;
          enableBashIntegration = true;
          # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=yaziPlugins
          plugins = {
            inherit (pkgs.yaziPlugins) yatline;
            inherit (pkgs.yaziPlugins) time-travel;
            inherit (pkgs.yaziPlugins) ouch;
            inherit (pkgs.yaziPlugins) piper;
            inherit (pkgs.yaziPlugins) lazygit;
            inherit (pkgs.yaziPlugins) chmod;
            inherit (pkgs.yaziPlugins) diff;
            inherit (pkgs.yaziPlugins) git;
          };
          initLua = ''
            -- https://github.com/yazi-rs/plugins/tree/main/git.yazi
            require("git"):setup()
          '';
          # https://yazi-rs.github.io/docs/configuration/yazi
          # ~/.config/yazi/yazi.toml
          settings = {
            plugin.prepend_fetchers = [
              # https://github.com/yazi-rs/plugins/tree/main/git.yazi
              {
                id = "git";
                name = "*";
                run = "git";
              }
              {
                id = "git";
                name = "*/";
                run = "git";
              }
            ];
            # https://yazi-rs.github.io/docs/configuration/yazi#mgr.linemode
            mgr.linemode = "mtime";
          };
          # https://yazi-rs.github.io/docs/configuration/keymap
          keymap = {
            mgr.prepend_keymap = [
              # https://github.com/iynaix/time-travel.yazi
              {
                on = [
                  "z"
                  "h"
                ];
                run = "plugin time-travel --args=prev";
                desc = "Go to previous snapshot";
              }
              {
                on = [
                  "z"
                  "l"
                ];
                run = "plugin time-travel --args=next";
                desc = "Go to next snapshot";
              }
              {
                on = [
                  "z"
                  "e"
                ];
                run = "plugin time-travel --args=exit";
                desc = "Exit browsing snapshots";
              }
              # https://github.com/yazi-rs/plugins/tree/main/chmod.yazi
              {
                on = [
                  "c"
                  "m"
                ];
                run = "plugin chmod";
                desc = "Chmod on selected files";
              }
            ];
          };
        };
      };
    });
  };
}
