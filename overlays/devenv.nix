# Overlay for devenv 2.1 from nixpkgs PR #516939
# Adds libghostty-vt and updates devenv to 2.1

_self: super:

let
  libghostty-vt-deps = import ./devenv/libghostty-vt-deps.nix {
    inherit (super)
      lib
      linkFarm
      fetchzip
      fetchurl
      fetchgit
      runCommandLocal
      zstd
      ;
    zig_0_15 = super.zig_0_15 or super.zig;
  };

  libghostty-vt = super.callPackage ./devenv/libghostty-vt.nix {
    inherit libghostty-vt-deps;
  };

  devenvNixVersion = "2.34";
  devenvNixRev = "42d4b7de21c15f28c568410f4383fa06a8458a40";

  devenvNixSrc = super.fetchFromGitHub {
    name = "devenv-nix-${devenvNixVersion}-source";
    owner = "cachix";
    repo = "nix";
    rev = devenvNixRev;
    hash = "sha256-g2KEBuHpc3a56c+jPcg0+w6LSuIj6f+zzdztLCOyIhc=";
  };

  nix_components = (super.nixVersions.nixComponents_git.overrideSource devenvNixSrc).overrideScope (
    _finalScope: _prevScope: {
      version = devenvNixVersion;
    }
  );

  devenv = super.rustPlatform.buildRustPackage {
    pname = "devenv";
    version = "2.1.0";

    src = super.fetchFromGitHub {
      owner = "cachix";
      repo = "devenv";
      tag = "v2.1";
      hash = "sha256-U7rb9FufadyCBLLsxVY6AJfy6TN24+uwaBBh8JVOP8s=";
    };

    cargoHash = "sha256-aONHe6r+lvXC45y6QeJ/tnVSHAYhy2IGuGWCrz+KVWc=";

    env = {
      RUSTFLAGS = "--cfg tracing_unstable";
      LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";
      DEVENV_IS_RELEASE = true;
    };

    cargoBuildFlags = [
      "-p"
      "devenv"
      "-p"
      "devenv-run-tests"
    ];

    nativeBuildInputs = [
      super.installShellFiles
      super.makeBinaryWrapper
      super.pkg-config
      super.protobuf
      super.rustPlatform.bindgenHook
    ];

    buildInputs = [
      super.openssl
      super.sqlite
      super.dbus
      libghostty-vt
      super.llvmPackages.clang-unwrapped
      nix_components.nix-expr-c
      nix_components.nix-store-c
      nix_components.nix-util-c
      nix_components.nix-flake-c
      nix_components.nix-cmd-c
      nix_components.nix-fetchers-c
      nix_components.nix-main-c
    ];

    nativeCheckInputs = [
      super.gitMinimal
      super.bash
    ];

    preCheck = ''
      pushd $NIX_BUILD_TOP/source
      git init -b main
      git config user.email "test@example.com"
      git config user.name "Test User"
      git add -A
      popd
    '';

    useNextest = true;
    cargoTestFlags = [
      "-p"
      "devenv"
    ];

    postInstall = ''
      wrapProgram $out/bin/devenv \
        --prefix PATH ":" "$out/bin:${super.lib.getBin super.cachix}/bin:${super.lib.getBin super.nixd}/bin" \
        ${super.lib.optionalString (
          super.glibcLocalesUtf8 != null
        ) "--set-default LOCALE_ARCHIVE ${super.glibcLocalesUtf8}/lib/locale/locale-archive"}

      wrapProgram $out/bin/devenv-run-tests \
        --prefix PATH ":" "$out/bin:${super.lib.getBin super.cachix}/bin:${super.lib.getBin super.nixd}/bin" \
        ${super.lib.optionalString (
          super.glibcLocalesUtf8 != null
        ) "--set-default LOCALE_ARCHIVE ${super.glibcLocalesUtf8}/lib/locale/locale-archive"}

      cargo xtask generate-manpages --out-dir man
      installManPage man/*

      compdir=./completions
      export PATH="$out/bin:$PATH"
      for shell in bash fish zsh; do
        cargo xtask generate-shell-completion $shell --out-dir $compdir
      done

      installShellCompletion --cmd devenv \
        --bash $compdir/devenv.bash \
        --fish $compdir/devenv.fish \
        --zsh $compdir/_devenv
    '';

    meta = {
      changelog = "https://github.com/cachix/devenv/releases";
      description = "Fast, Declarative, Reproducible, and Composable Developer Environments";
      homepage = "https://github.com/cachix/devenv";
      license = super.lib.licenses.asl20;
      mainProgram = "devenv";
      maintainers = with super.lib.maintainers; [
        domenkozar
        sandydoo
      ];
    };
  };
in
{
  inherit libghostty-vt devenv;
}
