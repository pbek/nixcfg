_:
{
  nix = {
    settings = {
      substituters = [
        # Local caliban nix binary cache
        "http://caliban.netbird.cloud:5000"
      ];
      trusted-public-keys = [
        "caliban.netbird.cloud:DqNB0rEKs3/A69mLvTL8tbyqmOZ8SY8OFZsSHkwvEVU="
      ];
    };
  };
}
