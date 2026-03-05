{
  pkgs,
  nixpkgs-unstable,
  ...
}:

let
  unstablePkgs = nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  # https://devenv.sh/reference/options/#cachixpull
  cachix.pull = [
    "devenv"
    "pbek-nixcfg-devenv"
  ];

  # languages.nix.enable = true;

  # https://devenv.sh/packages/
  packages =
    with pkgs;
    [
      git
      gum
    ]
    ++ [
      unstablePkgs.nh
      # Add more unstable packages here if needed, e.g. unstablePkgs.bat
    ];

  enterShell = ''
    echo "🛠️ pbek nixcfg dev shell"
  '';

  git-hooks.hooks = {
    statix.settings = {
      ignore = [ "hardware-configuration.nix" ];
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
