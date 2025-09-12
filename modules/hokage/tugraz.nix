{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.tugraz;
in
{
  options.hokage.tugraz = {
    enable = lib.mkEnableOption "Enable TU Graz infrastructure" // {
      default = cfg.enableExternal;
    };
    enableOrca = lib.mkEnableOption "Enable Orca screen reader support" // {
      default = cfg.enableExternal;
    };
    enableExternal = lib.mkEnableOption "Enable settings for externally managed desktop";
  };

  config = lib.mkIf (cfg.enable || cfg.enableExternal) {
    environment.systemPackages = with pkgs; [
      go-passbolt-cli
      # (pkgs.callPackage ../../pkgs/go-passbolt-cli/default.nix { })
      wstunnel # WebSocket tunnel for accessing local development environments
    ];

    # Add the openconnect plugin for NetworkManager
    networking.networkmanager.plugins = with pkgs; [
      networkmanager-openconnect
    ];

    # xdebug
    networking.firewall.allowedTCPPorts = [
      9000
      9003
      8888 # For the wstunnel websocket tunnel
    ];

    # Screen reader for visually impaired users
    services.orca.enable = cfg.enableOrca;
    # Fix for orca not working: The name org.a11y.Bus was not provided by any .service files
    services.gnome.at-spi2-core.enable = cfg.enableOrca;

    # https://home-manager-options.extranix.com
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      # https://searchix.alanpearce.eu/options/home-manager/search?query=git
      programs.git = {
        extraConfig = {
          url = {
            "ssh://git@gitlab.tugraz.at/" = {
              insteadOf = "https://gitlab.tugraz.at/";
            };
          };
          pull = {
            rebase = true;
          };
          rebase = {
            autoStash = true;
          };
          blame = {
            ignoreRevsFile = ".git-blame-ignore-revs";
          };
        };
      };
    });

    # Add common settings when externally managed
    hokage = {
      useInternalInfrastructure = lib.mkIf cfg.enableExternal (lib.mkDefault false);
      useSecrets = lib.mkIf cfg.enableExternal (lib.mkDefault false);
      useSharedKey = lib.mkIf cfg.enableExternal (lib.mkDefault false);
      espanso.enable = lib.mkIf cfg.enableExternal (lib.mkDefault false);
      jetbrains.phpstorm.enable = lib.mkIf cfg.enableExternal (lib.mkDefault true);
      languages.cplusplus.enable = lib.mkIf cfg.enableExternal (lib.mkDefault false);
    };
  };
}
