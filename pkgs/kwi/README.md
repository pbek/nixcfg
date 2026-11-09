# Kwi

Experimental GPU-accelerated KDE terminal from <https://invent.kde.org/utilities/kwi>.
The package includes the application, public QML terminal module, and KPart plugin.

From the repository root:

```sh
nix build path:.#kwi
nix run path:.#kwi
```

The overlay also makes `pkgs.kwi` available to host configurations. The Hokage
desktop module installs it by default; opt out with `hokage.excludePackages =
[ pkgs.kwi ];`. It is not selected as the default terminal automatically.

The Build Apps CI workflow and `just push` build Kwi and push its closure to the
`qownnotes` Attic cache.

Kwi is pinned to an upstream commit because there is no tagged release yet.
Its private libghostty-vt build uses the upstream 1.0.0 release and offline
dependency archive, matching Kwi's required VT API.
This does not override `pkgs.ghostty` or `pkgs.libghostty-vt`.
