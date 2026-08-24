# Backport Kate fixes for OpenLink URL parsing and Quick Open folder matching.
# https://invent.kde.org/utilities/kate/-/commit/80d0affb9686f866872bd15b9c4ba7f3d418b398
# https://invent.kde.org/utilities/kate/-/commit/6df9ec678a5558463866ab4a75977cd1f890cc58
# The OpenLink patch is rebased onto Kate 26.04.3 because the release is
# missing a test row that was added on master.
# Drop patches from this overlay once their fixes land in the Kate release
# shipped by nixpkgs.
_final: prev: {
  kdePackages = prev.kdePackages.overrideScope (
    _kfinal: kprev: {
      kate = kprev.kate.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./kde/kate-openlink-parens.patch
          ./kde/kate-quickopen-folder-match.patch
        ];
      });
    }
  );
}
