{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [
      pkgs.nodejs-18_x
      pkgs.php81
      pkgs.php81Extensions.ldap
      pkgs.php81Extensions.gd
      pkgs.php81Extensions.mysqli
      pkgs.php81Extensions.soap
      pkgs.php81Extensions.ldap
      pkgs.php81Extensions.mbstring
      pkgs.php81Extensions.xml
      pkgs.php81Extensions.intl
      pkgs.php81Extensions.apcu
      pkgs.php81Extensions.curl
      pkgs.php81Extensions.readline
      pkgs.php81Extensions.zip
      pkgs.php81Extensions.redis
      pkgs.php81Extensions.gmp
      pkgs.php81Extensions.sqlite3
      pkgs.php81Extensions.xdebug
      pkgs.php81Packages.composer
    ];
}
