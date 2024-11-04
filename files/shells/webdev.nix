{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs; [
      nodejs_22
      php83
      php83Extensions.ldap
      php83Extensions.gd
      php83Extensions.mysqli
      php83Extensions.soap
      php83Extensions.ldap
      php83Extensions.mbstring
      php83Extensions.xml
      php83Extensions.intl
#      php83Extensions.apcu
      php83Extensions.curl
      php83Extensions.readline
      php83Extensions.zip
      php83Extensions.redis
      php83Extensions.gmp
      php83Extensions.sqlite3
      php83Extensions.xdebug
      php83Packages.composer
    ];
}
