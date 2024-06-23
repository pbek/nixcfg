_:
{
  nix = {
    settings = {
      # If the cache servers are not available, https://cache.nixos.org will be used as a fallback.
      # https://hydra.nixos.org/build/263397466/download/1/manual/command-ref/conf-file.html#conf-fallback
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
