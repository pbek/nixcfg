final: prev: {
  # Use unreleased https://github.com/rcaloras/bash-preexec/pull/143
  # to fix https://github.com/nix-community/home-manager/issues/5958.
  # Note: we bump to include https://github.com/rcaloras/bash-preexec/pull/184
  # as well since the master branch has an annoying bug since 0.6.0.
  bash-preexec = prev.bash-preexec.overrideAttrs {
    src = final.fetchFromGitHub {
      owner = "rcaloras";
      repo = "bash-preexec";
      rev = "35fead9f3442bed7d096332c7845223f5dbf7faa";
      hash = "sha256-NcZxx7k2OkaeLtN2Iiu/fbstAIAA0QYRDEt37HAH/mg=";
    };
  };
}
