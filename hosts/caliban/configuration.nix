# Caliban TU Work PC

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  ...
}:
let
  inherit (config.hokage) userLogin;

  #  nixpkgs_multipass_pr = import (builtins.fetchTarball {
  #      # replace <commit> with the PR's head commit of NixOS/nixpkgs#439454
  #      url = "https://github.com/NixOS/nixpkgs/archive/5aa37bc5ce1ea85df3d04ac278b6a3784ed4cc88.tar.gz";
  #      sha256 = "sha256:109bj2i9nywgr4jn1bxmgc2fvp3x7ymrm4k8bczs79apry1r23r6";
  #    }) {
  #      inherit (pkgs) system;
  #      config = config.nixpkgs.config or {};
  #    };
in
{
  imports = [
    ./disk-config.zfs.nix
  ];

  networking = {
    hostName = "caliban";

    # Adding a 2nd IP address temporarily to the interface didn't work out, best use the ip command
    # `sudo ip addr add 192.168.1.100/255.255.255.0 dev eno1`
    #    interfaces.eno1 = {
    #      useDHCP = true;
    #      ipv4.addresses = [{ address = "192.168.1.100"; prefixLength = 24; }];
    #    };
  };

  environment.systemPackages = with pkgs; [
    soapui
    openldap
    gimp
    inkscape
    docker-slim # Docker image size optimizer and analysis tool
    amdgpu_top # AMD GPU monitoring
    lact # AMD GPU monitoring
  ];

  # Enable hardware accelerated graphics drivers
  hardware.graphics.enable = true;

  # https://wiki.nixos.org/wiki/AMD_GPU
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  # For testing https://gitlab.tugraz.at/vpu-private/ansible/
  # Multipass got removed, because it's unmaintained
  # virtualisation.multipass.enable = true;
  # Use stable multipass until, because of build issues with the latest version
  # virtualisation.multipass.package = pkgs.stable.multipass;
  #  virtualisation.multipass.package = nixpkgs_multipass_pr.multipass;

  #  users.users.omegah = {
  #    description = "Patrizio Bekerle Home";
  #  };

  # Try if another console fonts make the console apear
  # Disabled, because since the new installation with ZFS the console was very small
  #  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u12n.psf.gz";
  #  console.earlySetup = true;

  # Enable Nix-Cache
  # See ./README.md
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/etc/cache-priv-key.pem";
    openFirewall = true;
  };

  # We have enough RAM
  zramSwap.enable = false;

  # Increase the console font size for kmscon
  services.kmscon.extraConfig = "font-size = 26";

  users.users.${userLogin} = {
    openssh.authorizedKeys.keys = [
      # For letting astra build on caliban
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC50qr12/4ZU+xv2U20/kd6UPvX0Cgkc3XbslhFMlSde omega@astra"
    ];
  };

  hokage = {
    #    users = [
    #      "omega"
    #      "omegah"
    #    ];
    tugraz.enable = true;
    zfs = {
      enable = true;
      hostId = "dccada02";
      poolName = "calroot";
      encrypted = true;
    };
    programs.aider.enable = true;
    languages = {
      cplusplus.enable = false;
      go.enable = false;
    };
    plasma.enablePlasmaManager = true;
  };
}
