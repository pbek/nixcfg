{ lib, ... }:
{
  # Add the sanoid service to take snapshots of the ZFS datasets
  services.sanoid = {
    enable = true;
    templates = {
      hourly = {
        autoprune = true;
        autosnap = true;
        daily = 7;
        hourly = 24;
        monthly = 0;
      };
    };
    datasets = {
      "zroot/home" = {
        useTemplate = [ "hourly" ];
      };
      "zroot/docker" = {
        useTemplate = [ "hourly" ];
      };
    };
  };
}
