{
  pkgs,
  nixpkgs-unstable,
  ...
}:

let
  unstablePkgs = nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  # languages.nix.enable = true;

  # https://devenv.sh/packages/
  packages =
    with pkgs;
    [
      git
      gum
      just
    ]
    ++ [
      unstablePkgs.nh
      # Add more unstable packages here if needed, e.g. unstablePkgs.bat
    ];

  enterShell = ''
    echo "🛠️ pbek nixcfg dev shell"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    # https://devenv.sh/reference/options/#git-hookshookstreefmt
    # https://github.com/numtide/treefmt
    # https://github.com/numtide/treefmt-nix
    treefmt = {
      enable = true;
      settings.formatters = with pkgs; [
        nodePackages.prettier
        shfmt
        nixfmt-rfc-style
        statix
        taplo
      ];
    };

    # https://devenv.sh/reference/options/#git-hookshooksdeadnix
    # https://github.com/astro/deadnix
    deadnix = {
      enable = true;
      settings.exclude = [ "pkgs" ];
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
