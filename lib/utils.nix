{
  lib ? import <nixpkgs/lib>,
}:

rec {
  listNixFilesExcluding =
    exclude: path:
    let
      entries = builtins.readDir path;
      filtered = lib.filterAttrs (
        name: type:
        type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" && !(lib.elem name exclude)
      ) entries;
    in
    lib.mapAttrsToList (name: _: path + "/${name}") filtered;

  listNixFiles = listNixFilesExcluding [ ];

  listDirPathsExcluding =
    exclude: path:
    lib.mapAttrsToList (n: _: path + "/${n}") (
      lib.filterAttrs (n: _: n != "default.nix" && !notContains n exclude) (builtins.readDir path)
    );

  listDirPaths = listDirPathsExcluding [ ];
  contains = element: list: lib.any (x: x == element) list;
  notContains = element: list: lib.all (x: x != element) list;
}
