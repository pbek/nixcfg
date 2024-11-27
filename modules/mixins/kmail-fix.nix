{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Fall back to Qt5
  environment.systemPackages = with pkgs.libsForQt5; [
    kmail
    akonadi
    kdepim-runtime
  ];
}
