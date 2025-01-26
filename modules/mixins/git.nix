{
  config,
  pkgs,
  inputs,
  userNameLong,
  userEmail,
  lib,
  ...
}:
let
  userLogin = config.services.hokage.userLogin;
in
{
  # https://home-manager-options.extranix.com
  home-manager.users.${userLogin} = {
    programs.git = {
      enable = true;
      # use "git diff --no-ext-diff" for creating patches!
      difftastic.enable = true;
      userName = lib.mkDefault userNameLong;
      userEmail = lib.mkDefault userEmail;
      ignores = [
        ".idea"
        ".direnv"
      ];
      signing = {
        signByDefault = false;
        key = "E00548D5D6AC812CAAD2AFFA9C42B05E591360DC";
      };
    };

    # we had that file by default in the past
    home.file.".gitignore".text = ''
      .idea
      .direnv
      result
    '';

    # we had that file by default in the past
    # Migrate to https://search.nixos.org/options?channel=unstable&show=programs.git.config&from=0&size=50&sort=relevance&type=packages&query=programs.git
    home.file.".gitconfig".text = ''
      [user]
        name = ${userNameLong}
        email = ${userEmail}
        signingkey = E00548D5D6AC812CAAD2AFFA9C42B05E591360DC
      [gc]
        autoDetach = false
      [url "ssh://git@github.com/"]
        insteadOf = https://github.com/
      [url "ssh://git@gitlab.com/"]
        insteadOf = https://gitlab.com/
      [url "ssh://git@bitbucket.org/"]
        insteadOf = https://bitbucket.org/
      [url "ssh://git@gitlab.tugraz.at/"]
        insteadOf = https://gitlab.tugraz.at/
      [core]
        excludesfile = /home/${userLogin}/.gitignore
      [commit]
        gpgsign = false
      [gpg]
        program = gpg
      [pull]
        rebase = true
      [gui]
        pruneduringfetch = true
      [smartgit "submodule"]
        fetchalways = false
        update = true
        initializenew = true
      [push]
        recurseSubmodules = check
      [init]
        defaultBranch = main
    '';

    # Turn on signing off for git commits in lazygit
    home.file.".config/lazygit/config.yml".text = ''
      git:
        commit:
          signOff: true
    '';
  };
}
