# Temporary: matches the AWS-LC dependency fix in nixpkgs master.
# Remove once the pinned nixpkgs includes aws-lc and pkg-config here.
final: prev: {
  wstunnel = prev.wstunnel.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.pkg-config ];
    buildInputs = (old.buildInputs or [ ]) ++ [ final.aws-lc ];
  });
}
