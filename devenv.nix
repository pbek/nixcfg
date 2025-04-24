{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # Try to disable cachix to get served from local cache
  cachix.enable = false;

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    nh
    gum
    just

    # For treefmt
    treefmt
    nodePackages.prettier
    shfmt
    nixfmt-rfc-style
    statix
    taplo
  ];

  enterShell = ''
    echo "🛠️ pbek nixcfg dev shell"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks.treefmt.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
