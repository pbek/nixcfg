final: prev: {
  # Pull in https://github.com/kalbasit/ncps/pull/1331 until it is released.
  ncps = prev.ncps.overrideAttrs (old: {
    version = "0.9.4-pr1331";

    src = final.fetchFromGitHub {
      owner = "kalbasit";
      repo = "ncps";
      rev = "04cb40b94904bbca501080b5e82418c07fa2fca1";
      hash = "sha256-XFs+HUP10BGmFsGtvHX+/xuVZeXLe/BX+D5uKd7Tl+k=";
    };

    vendorHash = "sha256-ZGZNFIe2zuVpgtXbOx4JbW1Tec+1KDxxqUvRpBpYbqA=";

    doCheck = false;

    postInstall = ''
      wrapProgram $out/bin/ncps \
        --set XZ_BINARY_PATH ${final.lib.getExe' final.xz "xz"}

      # Compatibility with the nixpkgs 0.9.4 NixOS module. Newer ncps
      # releases provide database migrations through `ncps migrate`.
      makeWrapper $out/bin/ncps $out/bin/dbmate-ncps \
        --run 'export CACHE_DATABASE_URL="$DATABASE_URL"' \
        --add-flags migrate
    '';

    passthru = builtins.removeAttrs (old.passthru or { }) [ "dbmate-wrapper" ];
  });
}
