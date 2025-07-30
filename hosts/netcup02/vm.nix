#
# NixOS Netcup02 Test VM
#
# https://wiki.nixos.org/wiki/Cheatsheet#Building_a_service_as_a_VM_.28for_testing.29
# https://wiki.nixos.org/wiki/NixOS:nixos-rebuild_build-vm
# https://www.mankier.com/8/nixos-rebuild
#
# build in vm
# > nixos-rebuild --flake .#vm-netcup02 build-vm
#
{
  config,
  ...
}:
let
  inherit (config.hokage) userLogin;
in
{
  imports = [
    ./configuration.nix
  ];

  users.users.root.initialPassword = "root";
  users.users.${userLogin}.initialPassword = userLogin;
}
