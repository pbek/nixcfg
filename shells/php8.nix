# sudo nix-channel --add https://github.com/nix-community/NUR/archive/master.tar.gz nur
{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [
      pkgs.php82
      pkgs.php82Extensions.ldap
      pkgs.php82Extensions.gd
      pkgs.php82Extensions.mysqli
      pkgs.php82Extensions.soap
      pkgs.php82Extensions.ldap
      pkgs.php82Extensions.mbstring
      pkgs.php82Extensions.xml
      pkgs.php82Extensions.intl
      pkgs.php82Extensions.apcu
      pkgs.php82Extensions.curl
      pkgs.php82Extensions.readline
      pkgs.php82Extensions.zip
      pkgs.php82Extensions.redis
      pkgs.php82Extensions.gmp
      pkgs.php82Extensions.sqlite3
      pkgs.php82Extensions.xdebug
      pkgs.php82Packages.composer
      # pkgs.nur.repos.izorkin.php74
      # pkgs.nur.repos.izorkin.php74Packages.composer2
    ];
}
