# Temporary: rustdesk-flutter 1.5.0 needs system libsodium for its Rust build.
# Remove once the pinned nixpkgs includes libsodium in its buildInputs.
final: prev: {
  rustdesk-flutter = prev.rustdesk-flutter.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ final.libsodium ];
  });
}
