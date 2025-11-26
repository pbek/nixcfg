{
  config,
  lib,
  ...
}:
let
  inherit (config) hokage;
  inherit (hokage) userNameLong;
  inherit (hokage) userEmail;
  cfg = hokage.programs.git;

  inherit (lib)
    mkEnableOption
    ;
in
{
  options.hokage.programs.git = {
    enable = mkEnableOption "Git integration" // {
      default = hokage.role == "desktop" || hokage.role == "ally";
    };
    enableUrlRewriting = mkEnableOption "URL rewriting from HTTPS to SSH" // {
      default = hokage.role == "desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    # Workaround for git shell completions in fish shell
    # https://github.com/NixOS/nixpkgs/issues/462025
    # This workaround has a side effect with "just", see https://github.com/NixOS/nixpkgs/issues/462025#issuecomment-3581353705
    # programs.fish.interactiveShellInit = ''
    #   set -p fish_complete_path ${config.programs.fish.package}/share/fish/completions
    # '';

    # https://home-manager-options.extranix.com
    home-manager.users = lib.genAttrs hokage.users (_userName: {
      # https://searchix.alanpearce.eu/options/home-manager/search?query=git
      programs.git = {
        enable = true;
        ignores = [
          ".direnv"
          "result"
        ];
        signing = {
          signByDefault = lib.mkDefault (hokage.useInternalInfrastructure && hokage.useGraphicalSystem);
          key = lib.mkDefault "948530F2497017761DFCACC075960E6926556207";
        };
        # https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration
        settings = {
          user = {
            name = lib.mkDefault userNameLong;
            email = lib.mkDefault userEmail;
          };
          gc = {
            autoDetach = false;
          };
          # You can't bypass whose rules, you rather need to remove ~/.config/git/config
        }
        // lib.optionalAttrs cfg.enableUrlRewriting {
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
        }
        // {
          pull = lib.mkDefault {
            rebase = true;
          };
          rebase = lib.mkDefault {
            # https://git-scm.com/docs/git-config#Documentation/git-config.txt-rebaseautoStash
            autoStash = true;
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

      # use "git diff --no-ext-diff" for creating patches!
      programs.difftastic.enable = true;

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
