#
# NixOS Test VM
#
# https://nixos.wiki/wiki/Cheatsheet#Building_a_service_as_a_VM_.28for_testing.29
# https://nixos.wiki/wiki/NixOS:nixos-rebuild_build-vm
# https://www.mankier.com/8/nixos-rebuild
#
# build in vm
# > nixos-rebuild --flake /etc/nixos#vm build-vm
#
# build pr in vm
# > nixos-rebuild -I nixos-config=./vm.nix -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/pull/223593/head.tar.gz build-vm
# > QEMU_OPTS="-m 4096 -smp 4 -enable-kvm" ./result/bin/run-*-vm
#
{ lib, config, ... }:
{
    imports =
    [
      ../../modules/mixins/users.nix
      ../../modules/mixins/desktop-common.nix
      ../../modules/mixins/jetbrains.nix
      ../../modules/mixins/openssh.nix
      ../../modules/mixins/local-store-cache.nix
    ];

  users.users.root.initialPassword = "root";
  users.users.omega.initialPassword = "omega";
}
