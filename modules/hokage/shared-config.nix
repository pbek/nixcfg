{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userLogin;
  cfg = hokage.sharedConfig;

  inherit (lib)
    mkOption
    ;
in
{
  options.hokage.sharedConfig = {
    users = mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Shared configuration for users that modules can write to";
    };
    homeManager = mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Shared configuration for home-manager that modules can write to";
    };
  };

  config = {
    home-manager.users.${userLogin} = cfg.homeManager;
    users.users.${userLogin} = cfg.users;
  };
}
