# Workaround for plasma-vault 6.6.3 build failure:
# The nixpkgs default.nix passes fusermount to replaceVars, but the upstream
# hardcode-paths.patch for 6.6.3 no longer contains the @fusermount@ placeholder,
# causing substituteStream() to fail with --replace-fail.
# Remove fusermount from replaceVars until nixpkgs is fixed upstream.
_final: prev: {
  kdePackages = prev.kdePackages.overrideScope (
    _kfinal: kprev: {
      plasma-vault = kprev.plasma-vault.overrideAttrs (_old: {
        patches = [
          (prev.replaceVars (prev.path + "/pkgs/kde/plasma/plasma-vault/hardcode-paths.patch") {
            cryfs = prev.lib.getExe' prev.cryfs "cryfs";
            encfs = prev.lib.getExe' prev.encfs "encfs";
            encfsctl = prev.lib.getExe' prev.encfs "encfsctl";
            gocryptfs = prev.lib.getExe' prev.gocryptfs "gocryptfs";
            lsof = prev.lib.getExe prev.lsof;
          })
        ];
      });
    }
  );
}
