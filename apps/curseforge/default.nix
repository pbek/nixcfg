{ stdenv, lib, fetchzip, mkDerivation
, appimageTools
, autoPatchelfHook
, desktop-file-utils
}:

mkDerivation rec {
  pname = "curseforge";
  version = "1.250.2";
  name="${pname}-${version}";

  src = fetchzip {
      url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.zip";
      hash = "sha256-NxEeKr3d2NranpiAZ+stAEWjNqb/hphYP9Hkortdy2A=";
  };

  appextracted = appimageTools.extractType2 {
    inherit name;
    src="${src}/build/CurseForge-${version}-17763.AppImage";
  };

  dontBuild = true;
  dontConfigure = true;

#  nativeBuildInputs = [ imagemagick autoPatchelfHook desktop-file-utils ];
#  buildInputs = [ qtmultimedia stdenv.cc.cc ];

  installPhase = ''
      ls $out
#      binary="$(realpath ${appextracted}/AppRun)"
#      install -Dm755 $binary -t $out/bin
#
#      # fixup and install desktop file
#      desktop-file-install --dir $out/share/applications \
#        --set-key Exec --set-value $binary \
#        --set-key Comment --set-value "${meta.description}" \
#        --set-key Categories --set-value Network ${appextracted}/default.desktop
#      mv $out/share/applications/default.desktop $out/share/applications/SoulseekQt.desktop
#      #TODO: write generic code to read icon path from $binary.desktop
#      icon="$(realpath ${appextracted}/.DirIcon)"
#      for size in 16 32 48 64 72 96 128 192 256 512 1024; do
#        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
#        convert -resize "$size"x"$size" $icon $out/share/icons/hicolor/"$size"x"$size"/apps/$(basename $icon)
#      done
    '';

  meta = with lib; {
    description = "Curseforge";
    homepage = "https://www.curseforge.com";
    mainProgram = "Curseforge";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
