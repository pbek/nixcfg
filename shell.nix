{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    git
    nh
    gum
    just
  ];

  shellHook = ''
    # Symlink the pre-commit hook into the .git/hooks directory
    ln -sf ../../scripts/pre-commit.sh .git/hooks/pre-commit
  '';
}
