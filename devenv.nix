{
  pkgs,
  nixpkgs-unstable,
  lib,
  config,
  inputs,
  ...
}:

let
  unstablePkgs = nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  # https://devenv.sh/packages/
  packages =
    with pkgs;
    [
      git
      gum
      just

      # For treefmt
      treefmt
      nodePackages.prettier
      shfmt
      nixfmt-rfc-style
      statix
      taplo
    ]
    ++ [
      unstablePkgs.nh
      # Add more unstable packages here if needed, e.g. unstablePkgs.bat
    ];

  enterShell = ''
    echo "🛠️ pbek nixcfg dev shell"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks.treefmt.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
