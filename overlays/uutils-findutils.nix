# Temporary: matches the dependency fix in nixpkgs master.
# Remove once the pinned nixpkgs includes pkg-config and oniguruma here.
final: prev: {
  uutils-findutils = prev.uutils-findutils.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.pkg-config ];
    buildInputs = (old.buildInputs or [ ]) ++ [ final.oniguruma ];
  });
}
