{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userLogin;
  cfg = hokage.tugraz;
in
{
  options.hokage.tugraz = {
    enable = lib.mkEnableOption "Enable TU Graz infrastructure";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vpnc
      networkmanager-vpnc
      openconnect
      networkmanager-openconnect
      go-passbolt-cli
      # (pkgs.callPackage ../../pkgs/go-passbolt-cli/default.nix { })
    ];

    # xdebug
    networking.firewall.allowedTCPPorts = [
      9000
      9003
    ];

    # https://home-manager-options.extranix.com
    hokage.sharedConfig.homeManager = {
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
          blame = {
            ignoreRevsFile = ".git-blame-ignore-revs";
          };
        };
      };
    };
  };
}
