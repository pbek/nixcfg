{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config) hokage;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.hokage.programs.trippy;
in
{
  options.hokage.programs.trippy = {
    enable = mkEnableOption "Trippy configuration" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs = {
      fish = {
        shellAbbrs = {
          traceroute = "trip";
          mtr = "trip";
        };
      };
    };

    # https://trippy.rs/guides/privileges/#linux-only-set-capabilities
    security.wrappers.trip = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = "${pkgs.trippy}/bin/trip";
    };

    home-manager.users = lib.genAttrs hokage.usersWithRoot (_userName: {
      programs = {
        trippy = {
          enable = true;
          package = pkgs.trippy;
          # https://trippy.rs/reference/configuration/
          settings = {
            # https://trippy.rs/reference/theme/
            theme-colors = {
              # The background color was some light gray making it hard to read
              bg-color = "000000";
            };
          };
        };
      };
    });
  };
}
