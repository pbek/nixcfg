{ ... }:
{
  nix = {
    settings = {
      substituters = [
        # local attic
        "http://cicinas2.lan:8050/nix-store"
        # local nginx cache
        "http://cicinas2.lan:8282"
      ];
      trusted-public-keys = [
        "nix-store:p02fHdHXqUw9LSUgz8NiiTSnn+jbqBQ6XRypKz0axQw="
      ];
    };
  };
}
