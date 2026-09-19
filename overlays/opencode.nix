# Provide the requested OpenCode version until it lands in nixpkgs
_self: super:
let
  # Bun 1.4.1+ misorders shared chunks when compiling OpenCode.
  # https://github.com/oven-sh/bun/issues/42632
  sources = {
    "aarch64-darwin" = super.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.0/bun-darwin-aarch64.zip";
      hash = "sha256-xmnpf2Fk4cluBwF0jbmN+ndJKQjL2DlMdVcTSnNd44E=";
    };
    "aarch64-linux" = super.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.0/bun-linux-aarch64.zip";
      hash = "sha256-SxozLuhhmD65O8/m93D/+U4+MbLDiL2uo8jtNeWO7Q4=";
    };
    "x86_64-linux" = super.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v1.4.0/bun-linux-x64-baseline.zip";
      hash = "sha256-GE+0WV8NQBohfPfHjBvEMLqDMU2reouUgFurv3+nCX8=";
    };
  };
  bun = super.bun.overrideAttrs {
    version = "1.4.0";
    src = sources.${super.stdenvNoCC.hostPlatform.system};
    passthru.sources = sources;
  };
in
{
  opencode = super.callPackage ../pkgs/opencode/package.nix {
    inherit bun;
    models-dev = super.callPackage ../pkgs/opencode/models-dev.nix { };
  };
}
