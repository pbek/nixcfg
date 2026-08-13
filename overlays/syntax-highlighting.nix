_final: prev: {
  kdePackages = prev.kdePackages.overrideScope (
    _kfinal: kprev: {
      syntax-highlighting = kprev.syntax-highlighting.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./patches/0001-Add-Just-syntax-highlighting.patch
        ];
      });
    }
  );
}
