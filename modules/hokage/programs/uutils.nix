{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config) hokage;
  cfg = hokage.programs.uutils;

  #  coreutils-full-name =
  #    "coreuutils-full"
  #    + builtins.concatStringsSep "" (
  #      builtins.genList (_: "_") (builtins.stringLength pkgs.coreutils-full.version)
  #    );
  #
  #  coreutils-name =
  #    "coreuutils"
  #    + builtins.concatStringsSep "" (
  #      builtins.genList (_: "_") (builtins.stringLength pkgs.coreutils.version)
  #    );
  #
  #  findutils-name =
  #    "finduutils"
  #    + builtins.concatStringsSep "" (
  #      builtins.genList (_: "_") (builtins.stringLength pkgs.findutils.version)
  #    );
  #
  #  diffutils-name =
  #    "diffuutils"
  #    + builtins.concatStringsSep "" (
  #      builtins.genList (_: "_") (builtins.stringLength pkgs.diffutils.version)
  #    );
in
{
  options.hokage.programs.uutils = {
    enable = lib.mkEnableOption "uutils replacements for GNU utils, changes seems to need reboot" // {
      default = false;
      # default = hokage.role == "desktop" || hokage.role == "ally";
    };
  };

  config = lib.mkIf cfg.enable {
    # environment.corePackages = with pkgs; [ acl attr bashInteractive bzip2 coreutils-full cpio curl diffutils findutils gawk getent getconf gnugrep gnupatch gnused gnutar gzip xz less libcap ncurses netcat mkpasswd procps su time util-linux which zstd ];
    environment.corePackages = with pkgs; [
      acl
      attr
      bashInteractive
      bzip2
      uutils-coreutils-noprefix
      cpio
      curl
      uutils-diffutils
      uutils-findutils
      gawk
      getent
      getconf
      gnugrep
      gnupatch
      gnused
      gnutar
      gzip
      xz
      less
      libcap
      ncurses
      netcat
      mkpasswd
      procps
      su
      time
      util-linux
      which
      zstd
    ];

    #    environment.systemPackages = with pkgs; [
    #      # Rust replacements for coreutils, findutils, and diffutils
    #      # https://discourse.nixos.org/t/how-to-use-uutils-coreutils-instead-of-the-builtin-coreutils/8904/24
    #      (lib.hiPrio uutils-coreutils-noprefix)
    #      (lib.hiPrio uutils-findutils)
    #      (lib.hiPrio uutils-diffutils)
    #    ];
    #
    #    # Taken from https://wiki.nixos.org/wiki/Uutils
    #    system.replaceDependencies.replacements = [
    #      # coreutils
    #      {
    #        # system
    #        oldDependency = pkgs.coreutils-full;
    #        newDependency = pkgs.symlinkJoin {
    #          # Make the name length match so it builds
    #          name = coreutils-full-name;
    #          paths = [ pkgs.uutils-coreutils-noprefix ];
    #        };
    #      }
    #      {
    #        # applications
    #        oldDependency = pkgs.coreutils;
    #        newDependency = pkgs.symlinkJoin {
    #          # Make the name length match so it builds
    #          name = coreutils-name;
    #          paths = [ pkgs.uutils-coreutils-noprefix ];
    #        };
    #      }
    #      # findutils
    #      {
    #        # applications
    #        oldDependency = pkgs.findutils;
    #        newDependency = pkgs.symlinkJoin {
    #          # Make the name length match so it builds
    #          name = findutils-name;
    #          paths = [ pkgs.uutils-findutils ];
    #        };
    #      }
    #      # diffutils
    #      {
    #        # applications
    #        oldDependency = pkgs.diffutils;
    #        newDependency = pkgs.symlinkJoin {
    #          # Make the name length match so it builds
    #          name = diffutils-name;
    #          paths = [ pkgs.uutils-diffutils ];
    #        };
    #      }
    #    ];
  };
}
