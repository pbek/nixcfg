#{ appimageTools, fetchurl, lib }:
{
  pkgs ? import <nixpkgs> { },
  appimageTools,
  makeWrapper,
}:

let
  name = "curseforge";
  pname = "curseforge";
  version = "1.250.2";
  curseForgeAppImage = pkgs.stdenv.mkDerivation {
    name = "curseforge-appimage";
    src = pkgs.fetchurl {
      url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.zip";
      hash = "sha256-NxEeKr3d2NranpiAZ+stAEWjNqb/hphYP9Hkortdy2A=";
    };
    buildInputs = [ pkgs.unzip ]; # Required to unzip the archive

    installPhase = ''
      mkdir -p $out
      unzip $src -d $out
      mv $out/build/CurseForge-1.250.2-17763.AppImage $out/
    '';
    # Ensure we only get the AppImage as the result of this derivation
    outputFiles = [ "CurseForge-1.250.2-17763.AppImage" ];
  };
  src = curseForgeAppImage;
in
appimageTools.wrapType2 {
  name = "curseforge";
  src = curseForgeAppImage;

  extraPkgs = pkgs: with pkgs; [ ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      source "${makeWrapper}/nix-support/setup-hook"
      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-warn 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  #  meta = with lib; {
  #    description = "QOwnNotes command-line snippet manager";
  #    homepage = "https://github.com/qownnotes/qc";
  #    license = licenses.mit;
  #    maintainers = with maintainers; [ pbek totoroot ];
  #    platforms = platforms.linux ++ platforms.darwin;
  #  };
}
