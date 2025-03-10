{
  pkgs,
  config,
  lib,
  ...
}:
let
  userLogin = config.services.hokage.userLogin;
  termFontSize = config.services.hokage.termFontSize;
  useGhosttyGtkFix = config.services.hokage.useGhosttyGtkFix;
  ghosttyPackage =
    if useGhosttyGtkFix then
      (pkgs.ghostty.override {
        wrapGAppsHook4 = pkgs.wrapGAppsNoGuiHook.override {
          isGraphical = true;
          gtk3 =
            (pkgs.__splicedPackages.gtk4.override {
              wayland-protocols = pkgs.wayland-protocols.overrideAttrs (o: rec {
                version = "1.41";
                src = pkgs.fetchurl {
                  url = "https://gitlab.freedesktop.org/wayland/${o.pname}/-/releases/${version}/downloads/${o.pname}-${version}.tar.xz";
                  hash = "sha256-J4a2sbeZZeMT8sKJwSB1ue1wDUGESBDFGv2hDuMpV2s=";
                };
              });
            }).overrideAttrs
              (o: rec {
                version = "4.17.6";
                src = pkgs.fetchurl {
                  url = "mirror://gnome/sources/gtk/${lib.versions.majorMinor version}/gtk-${version}.tar.xz";
                  hash = "sha256-366boSY/hK+oOklNsu0UxzksZ4QLZzC/om63n94eE6E=";
                };
                postFixup = ''
                  demos=(gtk4-demo gtk4-demo-application gtk4-widget-factory)

                  for program in ''${demos[@]}; do
                    wrapProgram $dev/bin/$program \
                      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share/gsettings-schemas/${o.pname}-${version}"
                  done

                  # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
                  moveToOutput "share/doc" "$devdoc"
                '';
              });
        };
      })
    else
      pkgs.ghostty;
in
{
  environment.systemPackages = with pkgs; [
    ghosttyPackage
    # (callPackage ../../apps/ghostty/package.nix { })
  ];

  # https://rycee.gitlab.io/home-manager/options.html
  # https://nix-community.github.io/home-manager/options.html#opt-home.file
  home-manager.users.${userLogin} = {
    # Doc: https://ghostty.org/docs/config/reference
    # Config generator: https://ghostty.zerebos.com
    # Theme: https://github.com/catppuccin/ghostty/blob/main/themes/catppuccin-mocha.conf
    home.file.".config/ghostty/config".text = ''
      palette = 0=#45475a
      #palette = 1=#f38ba8  # this red doesn't work well as background color for error messages
      palette = 1=#b11818
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
