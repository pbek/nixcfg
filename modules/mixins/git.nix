{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  userLogin = config.services.hokage.userLogin;
  userNameLong = config.services.hokage.userNameLong;
  userEmail = config.services.hokage.userEmail;
  useInternalInfrastructure = config.services.hokage.useInternalInfrastructure;
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
        "result"
      ];
      signing = {
        # signByDefault = lib.mkDefault useInternalInfrastructure;
        signByDefault = lib.mkDefault false;
        key = lib.mkDefault "E00548D5D6AC812CAAD2AFFA9C42B05E591360DC";
      };
      extraConfig = {
          gc = {
            autoDetach = false;
          };
          url = {
            "ssh://git@github.com/" = {
              insteadOf = "https://github.com/";
            };
            "ssh://git@gitlab.com/" = {
              insteadOf = "https://gitlab.com/";
            };
            "ssh://git@bitbucket.org/" = {
              insteadOf = "https://bitbucket.org/";
            };
            "ssh://git@gitlab.tugraz.at/" = {
              insteadOf = "https://gitlab.tugraz.at/";
            };
          };
#          gpg = {
#            program = "gpg";
#          };
          pull = {
            rebase = true;
          };
          gui = {
            pruneduringfetch = true;
          };
          smartgit.submodule = {
            fetchalways = false;
            update = true;
            initializenew = true;
          };
          push = {
            recurseSubmodules = "check";
          };
          init = {
            defaultBranch = "main";
          };
        };
    };

    # Turn on signing off for git commits in lazygit
    home.file.".config/lazygit/config.yml".text = ''
      git:
        commit:
          signOff: true
    '';
  };
}
