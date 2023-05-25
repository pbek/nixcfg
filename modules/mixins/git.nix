{ config, pkgs, inputs, ... }:
{
  # https://rycee.gitlab.io/home-manager/options.html
  home-manager.users.omega = {
    programs.git = {
      enable = true;
      # use "git diff --no-ext-diff" for creating patches!
      difftastic.enable = true;
      userName  = "Patrizio Bekerle";
      userEmail = "patrizio@bekerle.com";
      ignores = [ ".idea" ".direnv" ];
      signing = {
        signByDefault = true;
        key = "E00548D5D6AC812CAAD2AFFA9C42B05E591360DC";
      };
    };

    # we had that file by default in the past
    home.file.".gitignore".text = ''
      .idea
      .direnv
    '';

    # we had that file by default in the past
    home.file.".gitconfig".text = ''
      [user]
        name = Patrizio Bekerle
        email = patrizio@bekerle.com
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
        excludesfile = /home/omega/.gitignore
      [commit]
        gpgsign = true
      [gpg]
        program = gpg
      [pull]
        rebase = false
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
  };
}
