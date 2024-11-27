_: {
  nix = {
    settings = {
      substituters = [
        # Local caliban nix binary cache
        "http://caliban-1.netbird.cloud:5000"
      ];
      trusted-public-keys = [
        "caliban-1.netbird.cloud:DqNB0rEKs3/A69mLvTL8tbyqmOZ8SY8OFZsSHkwvEVU="
      ];
    };
  };
}
