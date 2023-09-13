# sudo nix-channel --add https://github.com/nix-community/NUR/archive/master.tar.gz nur
{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs; [
      php81
      php81Extensions.ldap
      php81Extensions.gd
      php81Extensions.mysqli
      php81Extensions.soap
      php81Extensions.ldap
      php81Extensions.mbstring
      php81Extensions.xml
      php81Extensions.intl
      php81Extensions.apcu
      php81Extensions.curl
      php81Extensions.readline
      php81Extensions.zip
      php81Extensions.redis
      php81Extensions.gmp
      php81Extensions.sqlite3
      php81Extensions.xdebug
      php81Packages.composer
      # nur.repos.izorkin.php74
      # nur.repos.izorkin.php74Packages.composer2
    ];
}
