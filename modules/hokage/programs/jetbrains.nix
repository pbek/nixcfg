{
  config,
  pkgs,
  lib,
  nix-jetbrains-plugins,
  ...
}:
let
  inherit (config) hokage;
  cfg = hokage.programs.jetbrains;

  inherit (lib)
    mkEnableOption
    #    mkPackageOption
    mkOption
    types
    mkIf
    ;

  defaultJetbrainsPackages =
    if cfg.useStable then
      (import
        (fetchTarball {
          # Date: 20260623
          # https://github.com/NixOS/nixpkgs/commits/nixpkgs-unstable
          url = "https://github.com/NixOS/nixpkgs/tarball/89570f24e97e614aa34aa9ab1c927b6578a43775";
          sha256 = "sha256-EMzXKmnOtBQ2MnvpiNOm7E+kOMvdPrIKaeg52Tip2Uk=";
        })
        {
          inherit (config.nixpkgs) config;
          localSystem = {
            system = "x86_64-linux";
          };
        }
      )
    else
      #      (import
      #        (fetchTarball {
      #          # Date: 20260503
      #          # https://github.com/NixOS/nixpkgs/issues/425328
      #          url = "https://github.com/NixOS/nixpkgs/tarball/1c3fe55ad329cbcb28471bb30f05c9827f724c76";
      #          sha256 = "sha256-hGdgeU2Nk87RAuZyYjyDjFL6LK7dAZN5RE9+hrDTkDU=";
      #        })
      #        {
      #          inherit (config.nixpkgs) config;
      #          localSystem = {
      #            system = "x86_64-linux";
      #          };
      #        }
      #      );
      pkgs;

  # Drop this pin once our nixpkgs includes https://github.com/NixOS/nixpkgs/pull/593357.
  clionPrPackages =
    import
      (fetchTarball {
        url = "https://github.com/flaviut/nixpkgs/archive/7de8d3249c11c224c6518875405e953b209926ef.tar.gz";
        sha256 = "sha256-F2+6ob0ZvOpdXfw/N26/VI6pHNcUhxvmPwWI0SRdz4E=";
      })
      {
        inherit (config.nixpkgs) config;
        localSystem = pkgs.stdenv.hostPlatform;
      };

  # Unfortunately, we can't have per-application plugin settings
  #  mkJetbrainsPackage =
  #    name: cfgPackage:
  #    let
  #      inherit (cfg) plugins;
  #      basePackage =
  #        if builtins.isNull plugins || builtins.length plugins == 0 then
  #          cfgPackage
  #        else
  #          jetbrainsPackages.plugins.addPlugins cfgPackage plugins;
  #    in
  #    basePackage.overrideAttrs { preferLocalBuild = true; };

  mkJetbrainsIde =
    ideName:
    let
      useClionPr =
        ideName == "clion" && !cfg.useStable && lib.versionOlder pkgs.clion.version "2026.3.0.2";
      jetbrainsPackages = if useClionPr then clionPrPackages else defaultJetbrainsPackages;
      ide = jetbrainsPackages.jetbrains.${ideName};
      # The pinned plugin catalog lacks 2026.3.0.2. Look up plugins using the
      # preceding build in the same IDE series, without changing the installed IDE.
      clionNeedsCatalogFallback = ideName == "clion" && ide.version == "2026.3.0.2";
      pluginCatalogIde = if clionNeedsCatalogFallback then ide // { version = "2026.3.0.1"; } else ide;
      copilotId = "com.github.copilot";
      plugins = nix-jetbrains-plugins.lib.pluginsForIdeWith {
        extraOverrides =
          lib.optionalAttrs
            (
              (ideName == "phpstorm" || clionNeedsCatalogFallback)
              && lib.versions.majorMinor ide.version == "2026.3"
              && jetbrainsPackages.stdenv.hostPlatform.system == "x86_64-linux"
              && builtins.elem copilotId cfg.plugins
            )
            {
              # The catalog still selects 1.13.1-251, which calls a Jewel API removed in 2026.3.
              # This platform-specific archive ships only a native language server, so use
              # the base derivation's autoPatchelf instead of the upstream Node.js wrapper.
              ${copilotId} =
                plugin:
                plugin.overrideAttrs (old: rec {
                  version = "1.21.1-261-linux-x64";
                  src = jetbrainsPackages.fetchurl {
                    url = "https://plugins.jetbrains.com/files/17718/1221874/github-copilot-intellij-${version}.zip";
                    hash = "sha256-ptLUgY/n9ZYHqUGvz2vlNWBV4sgdtHNWlgBLbZZES2w=";
                  };
                  nativeBuildInputs = old.nativeBuildInputs ++ [
                    jetbrainsPackages.unzip
                    jetbrainsPackages.python3
                  ];
                  dontStrip = true;
                  postPatch = ''
                    chmod +x copilot-agent/native/linux-x64/copilot-language-server
                  '';
                  preFixup = ''
                    agent="$out/copilot-agent/native/linux-x64/copilot-language-server"
                    originalSize=$(stat -c %s "$agent")
                  '';
                  postPhases = [ "fixCopilotAgentOffsets" ];
                  fixCopilotAgentOffsets = ''
                    # patchelf moves the embedded Node.js payload, but not its stored offsets.
                    python3 - "$agent" "$originalSize" <<'PY'
                    import mmap
                    import sys

                    with open(sys.argv[1], "r+b") as binary, mmap.mmap(binary.fileno(), 0) as data:
                        shift = len(data) - int(sys.argv[2])
                        # Payload and prelude offsets in the pinned Marketplace archive.
                        for offset in (74205712, 165713775):
                            old = f"{offset:<16}".encode()
                            pos = data.find(old)
                            if pos == -1 or data.find(old, pos + 1) != -1:
                                raise RuntimeError(f"Expected one embedded offset: {offset}")
                            data[pos:pos + len(old)] = f"{offset + shift:<16}".encode()
                    PY
                    HOME="$TMPDIR" XDG_CACHE_HOME="$TMPDIR" "$agent" --version
                  '';
                });
            };
      } jetbrainsPackages pluginCatalogIde cfg.plugins;
    in
    jetbrainsPackages.jetbrains.plugins.addPlugins ide (lib.attrValues plugins);

in
{
  options.hokage.programs.jetbrains = {
    enable = mkEnableOption "JetBrains IDEs support";
    useStable = mkEnableOption "stable JetBrains packages" // {
      default = hokage.lowBandwidth; # Use stable JetBrains packages to save bandwidth
    };
    phpstorm = {
      enable = mkEnableOption "PhpStorm support";
      #      package = mkPackageOption jetbrainsPackages "phpstorm" {
      #        example = "phpstorm";
      #      };
    };
    clion = {
      enable = mkEnableOption "CLion support";
      #      package = mkPackageOption jetbrainsPackages "clion" {
      #        example = "clion";
      #      };
    };
    goland = {
      enable = mkEnableOption "Goland support";
      #      package = mkPackageOption jetbrainsPackages "goland" {
      #        example = "goland";
      #      };
    };
    # Documentation: https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/applications/editors/jetbrains
    # Bundled plugins where droped in https://github.com/NixOS/nixpkgs/pull/470147
    plugins = mkOption {
      type = types.listOf types.str;
      default = [
        # https://plugins.jetbrains.com/plugin/17718-github-copilot
        "com.github.copilot"
        # https://plugins.jetbrains.com/plugin/8607-nixidea
        "nix-idea"
      ];
      example = [ "nix-idea" ];
      description = ''
        List of JetBrains plugin IDs to install.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      #      lib.optionals cfg.phpstorm.enable [ (mkJetbrainsPackage "phpstorm" cfg.phpstorm.package) ]
      #      ++ lib.optionals cfg.clion.enable [ (mkJetbrainsPackage "clion" cfg.clion.package) ]
      #      ++ lib.optionals cfg.goland.enable [ (mkJetbrainsPackage "goland" cfg.goland.package) ];
      lib.optionals cfg.phpstorm.enable [ (mkJetbrainsIde "phpstorm") ]
      ++ lib.optionals cfg.clion.enable [ (mkJetbrainsIde "clion") ]
      ++ lib.optionals cfg.goland.enable [ (mkJetbrainsIde "goland") ];

    home-manager.users = lib.genAttrs hokage.users (_userName: {
      programs.fish.shellAliases = mkIf cfg.clion.enable {
        cl = "nix-shell /home/${_userName}/.shells/qt5.nix --run clion";
        cl6 = "nix-shell /home/${_userName}/.shells/qt6.nix --run clion";
      };

      # https://searchix.alanpearce.eu/options/home-manager/search?query=git
      programs.git.ignores = [ ".idea" ];

      xdg.desktopEntries = lib.mkMerge [
        # We still need a desktop entry that launches CLion in a nix-shell with the
        # necessary development packages, otherwise CMake won't find the libraries.
        # https://www.reddit.com/r/NixOS/comments/9xjbxc/clion_cmake_not_finding_libraries_on_nixos/
        (mkIf cfg.clion.enable {
          clion-nix-shell =
            let
              shellPath =
                if hokage.languages.cplusplus.qt6.enable then
                  "/home/${_userName}/.shells/qt6.nix"
                else
                  "/home/${_userName}/.shells/qt5.nix";
              #              clionPkg = mkJetbrainsPackage "clion" cfg.clion.package;
              clionPkg = mkJetbrainsIde "clion";
            in
            {
              name = "CLion with dev packages";
              genericName = "C/C++ IDE. New. Intelligent. Cross-platform";
              comment = "Test Enhancing productivity for every C and C++ developer on Linux, macOS and Windows.";
              icon = "${clionPkg}/share/pixmaps/clion.svg";
              exec = "nix-shell ${shellPath} --run clion";
              terminal = false;
              categories = [ "Development" ];
            };
        })
      ];
    });
  };
}
