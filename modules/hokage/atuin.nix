{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userLogin;
  inherit (hokage) useInternalInfrastructure;
  inherit (hokage) useSecrets;
  cfg = hokage.atuin;

  inherit (lib)
    mkEnableOption
    types
    ;
in
{
  options.hokage.atuin = {
    enable = mkEnableOption "Enable Atuin shell history" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # https://home-manager-options.extranix.com
    home-manager.users = lib.genAttrs hokage.users (userName: {
      programs = {
        # Sync your shell history across all your devices
        # https://docs.atuin.sh
        atuin = {
          #          package = pkgs.atuin.overrideAttrs (oldAttrs: rec {
          #            patches = oldAttrs.patches ++ [
          #              # Fix for up binding key for fish 4.0
          #              # https://github.com/atuinsh/atuin/pull/2616
          #              ../../pkgs/atuin/2616.patch
          #            ];
          #          });
          enable = true;
          daemon.enable = true;
          enableFishIntegration = true;
          # Writing to the atuin history doesn't work with bash
          # See https://github.com/nix-community/home-manager/issues/5958
          enableBashIntegration = false;
          # https://docs.atuin.sh/configuration/config/
          # Writes ~/.config/atuin/config.toml
          # If you have issues with home-manager not being able to link the file, because it was written by atuin
          # before home-manager could create the link, you need to create some symlink to the file yourself to block
          # atuin from creating that file!
          settings = {
            sync_address =
              if useInternalInfrastructure then "https://atuin.bekerle.com" else "https://api.atuin.sh";
            sync_frequency = "15m";
            key_path =
              if useSecrets then "/home/${userLogin}/.secrets/atuin-key" else "~/.local/share/atuin/key";
            enter_accept = true; # Enter runs command
            style = "compact"; # No extra box around UI
            inline_height = 32; # Maximum number of lines Atuin's interface should take up
            prefers_reduced_motion = true; # No automatic time updates
            # sync.records = true; # v2 sync (not working)
            workspaces = true; # Filter in directories with git repositories
            filter_mode = "workspace"; # Filter in directories with git repositories by default
            ctrl_n_shortcuts = true; # Use Ctrl, because Alt is taken by Ghostty
            # Fixes ZFS issues
            # See https://github.com/atuinsh/atuin/issues/952
            daemon = {
              enabled = true;
              systemd_socket = true;
            };
          };
        };

        # Add atuin init to bashrc, because it doesn't work with bashIntegration
        # But it still doesn't add anything to the Atuin history
        bash.bashrcExtra = ''
          eval "$(${pkgs.atuin}/bin/atuin init --disable-up-arrow bash)"
        '';
      };
    });
  };
}
