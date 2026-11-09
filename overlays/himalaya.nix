# Temporary: matches the dependency fix in nixpkgs master.
# Remove once the pinned nixpkgs includes libgit2 and sqlite here.
final: prev: {
  himalaya = prev.himalaya.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libgit2
      final.sqlite
    ];
  });
}
