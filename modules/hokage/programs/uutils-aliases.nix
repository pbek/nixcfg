{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hokage.programs.uutilsAliases;
in
{
  options.hokage.programs.uutilsAliases = {
    enable = lib.mkEnableOption "aliases for uutils to replace GNU coreutils in the shell" // {
      # default = !config.hokage.programs.uutils.enable;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      uutils-coreutils # GNU coreutils replacement
      stable.uutils-findutils # GNU findutils replacement
      # uutils-diffutils # GNU diffutils replacement, doesn't seem to be a drop in replacement
    ];

    # Replace GNU coreutils with uutils-coreutils
    programs.fish.shellAliases = {
      hostid = "uutils-hostid";
      sum = "uutils-sum";
      yes = "uutils-yes";
      hostname = "uutils-hostname";
      factor = "uutils-factor";
      uptime = "uutils-uptime";
      rmdir = "uutils-rmdir";
      # Ignore `printf` for now, because "utils-printf: warning: ignoring excess arguments, starting with 'trimmed_arg'"
      # printf = "uutils-printf";
      od = "uutils-od";
      basename = "uutils-basename";
      cut = "uutils-cut";
      cat = "uutils-cat";
      #    install = "uutils-install";
      rm = "uutils-rm";
      comm = "uutils-comm";
      mktemp = "uutils-mktemp";
      base64 = "uutils-base64";
      paste = "uutils-paste";
      readlink = "uutils-readlink";
      stdbuf = "uutils-stdbuf";
      mkdir = "uutils-mkdir";
      #    echo = "uutils-echo";
      basenc = "uutils-basenc";
      sync = "uutils-sync";
      wc = "uutils-wc";
      users = "uutils-users";
      csplit = "uutils-csplit";
      fold = "uutils-fold";
      unlink = "uutils-unlink";
      sleep = "uutils-sleep";
      pinky = "uutils-pinky";
      truncate = "uutils-truncate";
      nproc = "uutils-nproc";
      dir = "uutils-dir";
      cksum = "uutils-cksum";
      timeout = "uutils-timeout";
      chmod = "uutils-chmod";
      expr = "uutils-expr";
      whoami = "uutils-whoami";
      tr = "uutils-tr";
      #    test = "uutils-test";
      tail = "uutils-tail";
      who = "uutils-who";
      tac = "uutils-tac";
      tty = "uutils-tty";
      realpath = "uutils-realpath";
      mkfifo = "uutils-mkfifo";
      ls = "uutils-ls";
      logname = "uutils-logname";
      join = "uutils-join";
      groups = "uutils-groups";
      false = "uutils-false";
      env = "uutils-env";
      id = "uutils-id";
      dirname = "uutils-dirname";
      sort = "uutils-sort";
      stat = "uutils-stat";
      tee = "uutils-tee";
      nl = "uutils-nl";
      dircolors = "uutils-dircolors";
      expand = "uutils-expand";
      ptx = "uutils-ptx";
      pwd = "uutils-pwd";
      fmt = "uutils-fmt";
      dd = "uutils-dd";
      shred = "uutils-shred";
      uniq = "uutils-uniq";
      chroot = "uutils-chroot";
      du = "uutils-du";
      chown = "uutils-chown";
      chgrp = "uutils-chgrp";
      arch = "uutils-arch";
      tsort = "uutils-tsort";
      kill = "uutils-kill";
      mv = "uutils-mv";
      base32 = "uutils-base32";
      numfmt = "uutils-numfmt";
      mknod = "uutils-mknod";
      date = "uutils-date";
      printenv = "uutils-printenv";
      seq = "uutils-seq";
      pr = "uutils-pr";
      pathchk = "uutils-pathchk";
      #    true = "uutils-true";
      touch = "uutils-touch";
      ln = "uutils-ln";
      cp = "uutils-cp --progress";
      head = "uutils-head";
      nice = "uutils-nice";
      link = "uutils-link";
      split = "uutils-split";
      df = "uutils-df";
      shuf = "uutils-shuf";
      vdir = "uutils-vdir";
      unexpand = "uutils-unexpand";
      uname = "uutils-uname";
      more = "uutils-more";
      hashsum = "uutils-hashsum";
      nohup = "uutils-nohup";
      find = "${pkgs.stable.uutils-findutils}/bin/find";
      xargs = "${pkgs.stable.uutils-findutils}/bin/xargs";
      # diff = "${pkgs.uutils-diffutils}/bin/diffutils";
    };
  };
}
