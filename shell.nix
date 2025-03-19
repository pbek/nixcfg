{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    git
    statix
    nh
    gum
    just
    treefmt # formatting tool
    nodePackages.prettier # for webpage formatting
    shfmt # for shell formatting
    nixfmt-rfc-style # for nix formatting
  ];
}
