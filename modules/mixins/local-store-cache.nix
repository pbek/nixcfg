_:
{
  nix = {
    settings = {
      # If the cache servers are not available, https://cache.nixos.org will be used as a fallback.
      # https://hydra.nixos.org/build/263397466/download/1/manual/command-ref/conf-file.html#conf-fallback
      substituters = [
        # local home01 nix binary cache
        "http://home01.lan:5000"
        # local attic
        "http://cicinas2.lan:8050/nix-store"
        # local nginx cache
        "http://cicinas2.lan:8282"
      ];
      trusted-public-keys = [
        "home01.lan:/9arPyImijmvlBXeb8vVyOe67KH8Q7AeihW6MKtLDLQ="
        "nix-store:p02fHdHXqUw9LSUgz8NiiTSnn+jbqBQ6XRypKz0axQw="
      ];
    };
  };

  # Add static hosts in case there are troubles with DNS
  networking.hosts = {
    "192.168.1.115" = [ "home01.lan" ];
    "192.168.1.111" = [ "cicinas2.lan" ];
  };
}
