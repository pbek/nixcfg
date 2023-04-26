{ config, pkgs, inputs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  # https://rycee.gitlab.io/home-manager/options.html
  home-manager.users.omega = {
    programs.git = {
      enable = true;
      difftastic.enable = true;
      userName  = "Patrizio Bekerle";
      userEmail = "patrizio@bekerle.com";
      ignores = [ ".idea" ];
      signing = {
        signByDefault = true;
        key = "E00548D5D6AC812CAAD2AFFA9C42B05E591360DC";
      };

      # we had that file by default in the past
      home.file.".gitconfig".text = ''
        [user]
                name = Patrizio Bekerle
                email = patrizio@bekerle.com
                signingkey = E00548D5D6AC812CAAD2AFFA9C42B05E591360DC
        [url "ssh://git@github.com/"]
                insteadOf = https://github.com/
        [url "ssh://git@gitlab.com/"]
                insteadOf = https://gitlab.com/
        [url "ssh://git@bitbucket.org/"]
                insteadOf = https://bitbucket.org/
        [core]
                excludesfile = $HOME/.gitignore
        [commit]
                gpgsign = true
        [url "\"ssh://git@github.com/\""]
                insteadOf = https://github.com/
        [url "\"ssh://git@gitlab.com/\""]
                insteadOf = https://gitlab.com/
        [url "\"ssh://git@bitbucket.org/\""]
                insteadOf = https://bitbucket.org/
      '';
    };
  };
}
