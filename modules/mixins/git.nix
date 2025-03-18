{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  hokage = config.services.hokage;
  userLogin = hokage.userLogin;
  userNameLong = hokage.userNameLong;
  userEmail = hokage.userEmail;
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
        signByDefault = lib.mkDefault (hokage.useInternalInfrastructure && hokage.useGraphicalSystem);
        key = lib.mkDefault "948530F2497017761DFCACC075960E6926556207";
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
