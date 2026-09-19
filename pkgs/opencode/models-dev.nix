{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation {
  pname = "models-dev";
  version = "unstable";

  __structuredAttrs = true;
  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs = [ ];

  api = fetchurl {
    url = "https://models.dev/api.json";
    hash = "sha256-q3jMQSYg2ySjBL9bDWkqr5MIISqXdegnrajHKy9GTOU=";
  };
  models = fetchurl {
    url = "https://models.dev/models.json";
    hash = "sha256-Iv7vjhR4LDdOd4Etg1GALWlnRmbPkKksJd52GS+fAkI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dist
    cp $api $out/dist/_api.json
    cp $models $out/models.json

    runHook postInstall
  '';

  meta = {
    description = "Open-source database of AI models";
    homepage = "https://models.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      delafthi
      DuskyElf
      graham33
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
  };
}
