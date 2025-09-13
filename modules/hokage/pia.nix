{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) useSecrets;
  cfg = hokage.pia;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.pia = {
    enable = mkEnableOption "Enable Private Internet Access" // {
      default = hokage.role == "desktop" && hokage.useSecrets;
    };
  };

  config = lib.mkIf cfg.enable {
    # https://home-manager-options.extranix.com
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      # Set the path to the pia-manual repository and the userLogin and password for the PIA VPN script
      home.file."Scripts/pia.sh" = {
        text = ''
          #!/usr/bin/env bash
          # PIA startup script
          set -e
          cd "${inputs.pia}"
          sudo VPN_PROTOCOL=wireguard DISABLE_IPV6=yes DIP_TOKEN=no AUTOCONNECT=true PIA_PF=false PIA_DNS=false PIA_USER=$(cat "${config.age.secrets.pia-user.path}") PIA_PASS=$(cat "${config.age.secrets.pia-pass.path}") ./run_setup.sh
        '';
        executable = true;
      };

      # Set some fish shell aliases
      programs.fish.shellAliases = {
        pia-up = "~/Scripts/pia.sh";
        pia-down = "wg-quick down pia";
      };
    });
  };
}
