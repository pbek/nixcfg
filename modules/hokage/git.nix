{
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userNameLong;
  inherit (hokage) userEmail;
in
{
  config = lib.mkIf (hokage.role == "desktop") {
    # https://home-manager-options.extranix.com
    home-manager.users = lib.genAttrs hokage.users (userName: {
      # https://searchix.alanpearce.eu/options/home-manager/search?query=git
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
        # https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration
        extraConfig = {
          gc = {
            autoDetach = false;
          };
          # You can't bypass whose rules, you rather need to remove ~/.config/git/config
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
          };
          pull = lib.mkDefault {
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
          # https://git-scm.com/docs/git-blame#_configuration
          blame = lib.mkDefault {
            ignoreRevsFile = ".git-blame-ignore-revs";
          };
        };
      };

      # Helper for merge conflicts for git
      # https://mergiraf.org/
      programs.mergiraf.enable = true;

      # Turn on signing off for git commits in lazygit
      home.file.".config/lazygit/config.yml".text = ''
        git:
          commit:
            signOff: true
      '';
    });
  };
}
