# sudo nix-channel --add https://github.com/nix-community/NUR/archive/master.tar.gz nur
{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs; [
      php84
      php84Extensions.ldap
      php84Extensions.gd
      php84Extensions.mysqli
      php84Extensions.soap
      php84Extensions.ldap
      php84Extensions.mbstring
      php84Extensions.xml
      php84Extensions.intl
#      php84Extensions.apcu
      php84Extensions.curl
      php84Extensions.readline
      php84Extensions.zip
      php84Extensions.redis
      php84Extensions.gmp
      php84Extensions.sqlite3
#      php84Extensions.xdebug
      php84Packages.composer
      # nur.repos.izorkin.php74
      # nur.repos.izorkin.php74Packages.composer2
    ];
}
