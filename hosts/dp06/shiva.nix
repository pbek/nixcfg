# Shared Config Shiva

{
  pkgs,
  ...
}:
{
  imports = [
    ./disk-config.zfs.nix
  ];

  environment.systemPackages = with pkgs; [
    thunderbird
    spotify
    inkscape
  ];

  hokage = {
    # "user" was the old login, we will keep it, to stay out of trouble
    userLogin = "user";
    userNameLong = "Shiva Pouya";
    userNameShort = "Shiva";
    userEmail = "shiva.pouya@tugraz.at";
    tugraz.enableExternal = true;
    zfs.enable = true;
  };
}
