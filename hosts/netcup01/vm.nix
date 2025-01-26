#
# NixOS Netcup01 Test VM
#
# https://nixos.wiki/wiki/Cheatsheet#Building_a_service_as_a_VM_.28for_testing.29
# https://nixos.wiki/wiki/NixOS:nixos-rebuild_build-vm
# https://www.mankier.com/8/nixos-rebuild
#
# build in vm
# > nixos-rebuild --flake .#vm-netcup01 build-vm
#
{ lib, config, ... }:
let
  userLogin = config.services.hokage.userLogin;
in
{
  imports = [
    ./configuration.nix
  ];

  users.users.root.initialPassword = "root";
  users.users.${userLogin}.initialPassword = userLogin;
}
