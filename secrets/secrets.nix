# https://github.com/ryantm/agenix#tutorial

let
  # yubikey = "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@i7work";

  # ssh-keygen -t ed25519 -C "age@system" -f ~/.ssh/agenix
  agenix = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEqdKjeVeHFJqCJbwAjol6p5SF5ylkcec8z55WnjbgZ age@system" ];

  # ssh-key-scan localhost
  eris = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrtITL0ILvGjnMPWjCt9Dh89ptJH/HPn/lZz8n87Iuw8PGgXuhkxMoONcRC+NsuF+KJokIxEMTkEd1duIG73O7ZqfV6EdIfnEKXOtH8cj6e3liw0NnD1WQ3Yk7B2uJCzZ/xw4I9ZrcgwlvP/PTF8Fqksxl1uBITCeBriEHg8ykHR0BiTiN4NtAgvnZPXyjFs4N3MKLnGKM20LnF2/3bA7RiCoRmSvEMSxS7AH/4y4FIO0YT/UhLlvz9y5ybdAHdFDsx0gKqgmlMac0gX1or7H5GrvXoan+mVWtHiUxIlzHA7eEb/YML7mLxTKyg/zMkUN17IWHomy/J13YTOG/6NmXBRQu9dxcKeCYM5HQzbT/fbFVh9P7LcPLB1YF2Co/REP6tVfpfUUJkfltnPY3inKxL4Z4kY3ApD/zU7eChO1U5hOFds6QAWTc5Wqcu4MX64BDjgJ/kdFHfDdLkfhqXey2h6zi5m6XRn9SqOfgB/4J9/2E+ciQwo+IkzH0jEG/BI06FrImPzxmSCv9WL92ZcahGjv2M0bfwuxrABfCTIMbiBKWIXkI3gK5vueScLgkmJwB+hlrz50ihy7Y6GJG0LUWKUbcxbaOcrqbktZPAqtfCaWlZAVZ3KZ+hZ2X2W3ER8ZwUzxyxf2TV0ClklJE88sADggIkoNc4lJzHaGwQl64sw=="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbPF7yvUf3zMuMOQ72YLRs95nepjB+y8PHa1T0KNhn/"
  ];
  neptun = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCcugjuq4rblhmKR2LtJnq6S0zdF5Yh+eM4Z5fPkySblTRix7/Re67LTIfaTa9kxJqhdQlsDoDVkriiuchMeKcAoROOzEzou3FKcBfKnGvz/lHMSv/dizGEp3l8T2buVqSk8kr/XO732l+obMdgwxP45TC8Zjr9nK4VoK4HcGFV2hgmzdGxM+0tQiTQKW8gzGrjlOdoMH/51iF/sueOh5yo7J+GGyn0vF6ewDzcTvu7giC0/qShYcGM5Kq4NaKwfSS05X8zBG7/kkLl9vV0HmSkS367LAQ4GRrdE84mxX3JmGgoC8D3qID5TKGTMvzf5e7mXsaQC3Q4zyhBJuzfPK54+VRKk0NuAKtn7dQI7Hvu5iU7KbU/NI+iJgU+UCQVeipB1EPFUiGbHwwQq1N+10KjRd3M4d6Uc9u7Lohah3xHlkR0u+TKUF8vSNZFrfeCskaIkDJUoRN4qfzXiYQ5BbBFnpZOISwZY0WrUio6WGLrZjW5Pptkvu/rrj8w3TQGlGSKfpfbTK8dmLlQZXkacgp+xLQy2EQ5Rtr8PFAwlsxyDx/IWLvd4Iu5Dr0tyPVeXd5/Tye0MC7jdv78xmGgdHeU4SyAYrC5LQfsUO5OaOIUjayyBFEm8pU7+PtVPFAKmj6c4ULuBzE42sW8gJXqNLnD9bu8GFEXJCkD24fE2tl4Jw=="
    "ssh-rsa ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTrgA0Cj9Q7DdWD98F+fYqIDvtDNk7irur1kd42tie"
  ];

  systems = agenix ++ eris ++ neptun;
in
{
  # agenix -i ~/.ssh/agenix -e secret1.age
  "secret1.age".publicKeys = systems;
}
