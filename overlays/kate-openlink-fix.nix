# Fix kate OpenLink addon including unbalanced trailing ')' in detected URLs.
# Backport of https://invent.kde.org/utilities/kate/-/commit/80d0affb9686f866872bd15b9c4ba7f3d418b398
# rebased onto kate 26.04.3 (the original patch fails to apply because the
# release is missing a test row that was added on master).
# Drop this overlay once the fix lands in a kate release shipped by nixpkgs.
_final: prev: {
  kdePackages = prev.kdePackages.overrideScope (
    _kfinal: kprev: {
      kate = kprev.kate.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./kde/kate-openlink-parens.patch ];
      });
    }
  );
}
