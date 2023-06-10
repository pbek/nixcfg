{ ... }:
{
  nix = {
    settings = {
      substituters = [
        "http://cicinas2.lan:8050/nix-store"
      ];
      trusted-public-keys = [
        "nix-store:p02fHdHXqUw9LSUgz8NiiTSnn+jbqBQ6XRypKz0axQw="
      ];
    };
  };
}
