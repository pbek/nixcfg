# Temporary: the Rust hooks require system Oniguruma, but fresh-editor
# does not yet declare it in the pinned nixpkgs package.
final: prev: {
  fresh-editor = prev.fresh-editor.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ final.oniguruma ];
  });
}
