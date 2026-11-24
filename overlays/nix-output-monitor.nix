# Backport support for unknown Nix log events (including Nix 2.36 store copies).
# Remove once the devenv nixpkgs pin includes this fix.
# https://github.com/maralorn/nix-output-monitor/pull/321
_final: prev:
let
  nom = prev.nix-output-monitor;
  patch = prev.fetchpatch {
    url = "https://github.com/maralorn/nix-output-monitor/commit/d48ff7935da72a5a5764ee8c5358d38417b0f337.patch";
    stripLen = 1;
    hash = "sha256-83jk9DwNJZFbPzG6g9G8fW165hLolA1MjyerpqN9T3s=";
  };
  hasPatch = prev.lib.any (existing: toString existing == toString patch) (nom.patches or [ ]);
in
{
  nix-output-monitor =
    if nom.version == "2.2.0" && !hasPatch then
      nom.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ patch ];
      })
    else
      nom;
}
