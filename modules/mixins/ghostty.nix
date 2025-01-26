{
  pkgs,
  config,
  termFontSize,
  ...
}:
let
  userLogin = config.services.hokage.userLogin;
in
{
  environment.systemPackages = with pkgs; [
    ghostty
    # (pkgs.callPackage ../../apps/ghostty/package.nix { })
  ];

  # https://rycee.gitlab.io/home-manager/options.html
  # https://nix-community.github.io/home-manager/options.html#opt-home.file
  home-manager.users.${userLogin} = {
    # Doc: https://ghostty.org/docs/config/reference
    # Config generator: https://ghostty.zerebos.com
    # Theme: https://github.com/catppuccin/ghostty/blob/main/themes/catppuccin-mocha.conf
    home.file.".config/ghostty/config".text = ''
      palette = 0=#45475a
      palette = 1=#f38ba8
      palette = 2=#a6e3a1
      palette = 3=#f9e2af
      palette = 4=#89b4fa
      palette = 5=#f5c2e7
      palette = 6=#94e2d5
      palette = 7=#bac2de
      palette = 8=#585b70
      palette = 9=#f38ba8
      palette = 10=#a6e3a1
      palette = 11=#f9e2af
      palette = 12=#89b4fa
      palette = 13=#f5c2e7
      palette = 14=#94e2d5
      palette = 15=#a6adc8
      #background = 1e1e2e
      background = 0e0e15
      #foreground = cdd6f4
      cursor-color = f5e0dc
      selection-background = 353749
      selection-foreground = cdd6f4

      window-new-tab-position = end
      font-size = ${toString termFontSize}
    '';
  };
}
