_: {
  nix = {
    settings = {
      substituters = [
        # Local caliban nix binary cache
        "http://caliban-1.netbird.cloud:5000"
      ];
      trusted-public-keys = [
        "caliban-1.netbird.cloud:pSAazh7Bk3TCDrx5+V1sJZxyCB4R8HpXOBVyJufFqRA="
      ];
    };
  };
}
