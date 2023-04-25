# NixOS Test VM
#
# nixos-rebuild -I nixos-config=./vm.nix build-vm
{ lib, config, ... }:
{
    imports =
    [ # Include the results of the hardware scan.
    ./modules/mixins/users.nix
    ./modules/mixins/desktop-common.nix
#    ./modules/mixins/jetbrains.nix
#    ./modules/editor/nvim.nix
    # this brought me an infinite recursion
#    mixins-openssh
    ];

  services.tor.enable = true;
  users.users.root.initialPassword = "root";
  users.users.omega.initialPassword = "omega";
}

