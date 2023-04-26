# https://github.com/ryantm/agenix#tutorial

let
  # yubikey = "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@i7work";

  # ssh-keygen -t ed25519 -C "age@system" -f ~/.ssh/agenix
  agenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEqdKjeVeHFJqCJbwAjol6p5SF5ylkcec8z55WnjbgZ age@system";

  # ssh-key-scan localhost
  eris1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbPF7yvUf3zMuMOQ72YLRs95nepjB+y8PHa1T0KNhn/";
  eris2 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrtITL0ILvGjnMPWjCt9Dh89ptJH/HPn/lZz8n87Iuw8PGgXuhkxMoONcRC+NsuF+KJokIxEMTkEd1duIG73O7ZqfV6EdIfnEKXOtH8cj6e3liw0NnD1WQ3Yk7B2uJCzZ/xw4I9ZrcgwlvP/PTF8Fqksxl1uBITCeBriEHg8ykHR0BiTiN4NtAgvnZPXyjFs4N3MKLnGKM20LnF2/3bA7RiCoRmSvEMSxS7AH/4y4FIO0YT/UhLlvz9y5ybdAHdFDsx0gKqgmlMac0gX1or7H5GrvXoan+mVWtHiUxIlzHA7eEb/YML7mLxTKyg/zMkUN17IWHomy/J13YTOG/6NmXBRQu9dxcKeCYM5HQzbT/fbFVh9P7LcPLB1YF2Co/REP6tVfpfUUJkfltnPY3inKxL4Z4kY3ApD/zU7eChO1U5hOFds6QAWTc5Wqcu4MX64BDjgJ/kdFHfDdLkfhqXey2h6zi5m6XRn9SqOfgB/4J9/2E+ciQwo+IkzH0jEG/BI06FrImPzxmSCv9WL92ZcahGjv2M0bfwuxrABfCTIMbiBKWIXkI3gK5vueScLgkmJwB+hlrz50ihy7Y6GJG0LUWKUbcxbaOcrqbktZPAqtfCaWlZAVZ3KZ+hZ2X2W3ER8ZwUzxyxf2TV0ClklJE88sADggIkoNc4lJzHaGwQl64sw==";
  systems = [ agenix eris1 eris2 ];
in
{
  # agenix -i ~/.ssh/agenix -e secret1.age
  "secret1.age".publicKeys = systems;
}
