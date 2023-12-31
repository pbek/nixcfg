{ config, pkgs, ... }:

{
  home-manager.users.omega = {
    services.espanso = {
      enable = true;
      matches = {
        base = {
          # https://espanso.org/docs/matches/basics/
          matches = [
            {
              trigger = ":sg";
              replace = "Sehr geehrter ";
            }
            {
              trigger = ":lg";
              replace = "Liebe Grüße Patrizio";
            }
            {
              trigger = ":glg";
              replace = "Ganz liebe Grüße Patrizio";
            }
            {
              trigger = ":mfg";
              replace = "Mit freundlichen Grüßen\nPatrizio Bekerle\n";
            }
            {
              trigger = ":date";
              replace = "{{mydate}}";
              vars = [
                {
                  name = "mydate";
                  type = "date";
                  params = {
                    format = "%d.%m.%Y";
                  };
                }
              ];
            }
            {
              trigger = ":ghrel";
              replace = "There now is a new release, could you please test it and report if it works for you?\n";
            }
            {
              triggers = [ ":ghtest" ":ghtst" ];
              replace = "Great, thank you for testing!\n";
            }
            {
              triggers = [ ":ghexp" ];
              replace = "Can you please explain in more detail and step by step what you did, what happened and what you expected.\n";
            }
            {
              triggers = [ ":ghnotetree" ":ghwip" ":gh790" ];
              replace = ''
                Looks like you are talking about the work in progress feature #790, right?
                If yes, then best deposit your request there... 😉
              '';
            }
            {
              trigger = ":ghscr";
              replace = ''
                Can you please mention the authors of the script, like advised in the issue template?
                You will find the authors in the *Script repository*.
                Don't forget to use the `@` symbol to mention them.
              '';
            }
            {
              triggers = [ ":ghrep" ":ghlog" ];
              replace = ''
                Thank you for reporting.
                Can you please post the output from the *Debug settings* in the settings dialog? You just need to paste it here.
                And is there any useful log output if you enable the log panel (see Window / Panels)?
                Please make sure you also enable debug logging in the log panel by right-clicking on the panel and selecting `Debug` in `Options`.
                The issue dialog in the help menu can help you with all of that.
              '';
            }
          ];
        };
      };
    };
  };
}