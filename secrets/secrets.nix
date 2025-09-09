# https://github.com/ryantm/agenix#tutorial

let
  # yubikey = "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFDWxqigrXdCx7mX/yvBpHJf2JIab9HIrjof+sCbn0cOr/NySAirjE7tWxkZJPBrUs/8wSgn/rFO742O+NkOXTYAAAAEc3NoOg== omega@i7work";

  # ssh-keygen -t ed25519 -C "age@system" -f ~/.ssh/agenix
  agenix = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEqdKjeVeHFJqCJbwAjol6p5SF5ylkcec8z55WnjbgZ age@system"
  ];

  # Workflow: https://github.com/ryantm/agenix/issues/17#issuecomment-797174338
  # ssh-key-scan localhost
  eris = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrtITL0ILvGjnMPWjCt9Dh89ptJH/HPn/lZz8n87Iuw8PGgXuhkxMoONcRC+NsuF+KJokIxEMTkEd1duIG73O7ZqfV6EdIfnEKXOtH8cj6e3liw0NnD1WQ3Yk7B2uJCzZ/xw4I9ZrcgwlvP/PTF8Fqksxl1uBITCeBriEHg8ykHR0BiTiN4NtAgvnZPXyjFs4N3MKLnGKM20LnF2/3bA7RiCoRmSvEMSxS7AH/4y4FIO0YT/UhLlvz9y5ybdAHdFDsx0gKqgmlMac0gX1or7H5GrvXoan+mVWtHiUxIlzHA7eEb/YML7mLxTKyg/zMkUN17IWHomy/J13YTOG/6NmXBRQu9dxcKeCYM5HQzbT/fbFVh9P7LcPLB1YF2Co/REP6tVfpfUUJkfltnPY3inKxL4Z4kY3ApD/zU7eChO1U5hOFds6QAWTc5Wqcu4MX64BDjgJ/kdFHfDdLkfhqXey2h6zi5m6XRn9SqOfgB/4J9/2E+ciQwo+IkzH0jEG/BI06FrImPzxmSCv9WL92ZcahGjv2M0bfwuxrABfCTIMbiBKWIXkI3gK5vueScLgkmJwB+hlrz50ihy7Y6GJG0LUWKUbcxbaOcrqbktZPAqtfCaWlZAVZ3KZ+hZ2X2W3ER8ZwUzxyxf2TV0ClklJE88sADggIkoNc4lJzHaGwQl64sw=="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbPF7yvUf3zMuMOQ72YLRs95nepjB+y8PHa1T0KNhn/"
  ];
  neptun = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCcugjuq4rblhmKR2LtJnq6S0zdF5Yh+eM4Z5fPkySblTRix7/Re67LTIfaTa9kxJqhdQlsDoDVkriiuchMeKcAoROOzEzou3FKcBfKnGvz/lHMSv/dizGEp3l8T2buVqSk8kr/XO732l+obMdgwxP45TC8Zjr9nK4VoK4HcGFV2hgmzdGxM+0tQiTQKW8gzGrjlOdoMH/51iF/sueOh5yo7J+GGyn0vF6ewDzcTvu7giC0/qShYcGM5Kq4NaKwfSS05X8zBG7/kkLl9vV0HmSkS367LAQ4GRrdE84mxX3JmGgoC8D3qID5TKGTMvzf5e7mXsaQC3Q4zyhBJuzfPK54+VRKk0NuAKtn7dQI7Hvu5iU7KbU/NI+iJgU+UCQVeipB1EPFUiGbHwwQq1N+10KjRd3M4d6Uc9u7Lohah3xHlkR0u+TKUF8vSNZFrfeCskaIkDJUoRN4qfzXiYQ5BbBFnpZOISwZY0WrUio6WGLrZjW5Pptkvu/rrj8w3TQGlGSKfpfbTK8dmLlQZXkacgp+xLQy2EQ5Rtr8PFAwlsxyDx/IWLvd4Iu5Dr0tyPVeXd5/Tye0MC7jdv78xmGgdHeU4SyAYrC5LQfsUO5OaOIUjayyBFEm8pU7+PtVPFAKmj6c4ULuBzE42sW8gJXqNLnD9bu8GFEXJCkD24fE2tl4Jw=="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTrgA0Cj9Q7DdWD98F+fYqIDvtDNk7irur1kd42tie"
  ];
  pluto = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9FJtqLS4z9OjT+q50bX32M6T4R0NEJvhlVQVinQPOocUTHep6oJ0gyiFh0BIw4P9zjLZNtknpC93846NwlQ4y2/jZ6FbccwQ5jsujeuGLLkDohO2tx08FLEsUimuVqoJ7eGeGFuWV4OxsbyT6C4ONbquv89ns+Kep7c8qzkGBZNF+8ZSwfzo8Ai7TMirpoFMghucpplvdfRHzquKocXuFtiT0L+Hwf6nSWxuMYeEu03DwBO62ad6C13IDrnz0+GIgXAqXnrO8quxmAee8yel2geJxiUJenEVljtcEX4qPJJATwA4tcsP8sNZnbl/MvyOFC5WaMY24i8nGifwY5nCXesw/8ZGBEILmMYXG+M5KRVycAoZC2fjZevZpdZFHcH/ZDWzT0RqHOHmAoP8+yzhGaKH2zskzOSHPqbOHtNrWu6rEwYUdzs8ZJ69ltlVhYUMXwq5QwLfMe+u64tMMh7A4PS2qQhOrfqjOgF6yUhNAe2q11obqe1xRWIT5gcQ9jVNyn1grh/vmqtZ+7SyjkLjcgmHaTtzRfO6SMHWaMPgJNSnAdQnYClmx6o/pJVSsvvxIjFvumAWYtryuX8r4ub9fo37DcTYC88ZEDaSFvyBdg4iXICthWxC8Je8lLRkopGa5sc8j5qateNiBuix9n72Fl5IgJjAnHIKvgQ+cUdUrpw=="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKIIw3VsyVzxEmjj5PMQrgZkWazaykAZF/KA6RlcUCDE"
  ];
  jupiter = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDe7CA72y/S2sxRSdoMeCHNAXLEKJDHcSrz9Cc55XzKhLZxHDiAbQSjFu7Bci/v/w4pxAmNRm2B72XVtrSgN/WJw6oO+jsO5/4vQDyOKZkKZBTTYNp480yMMgFMWyKXaFq2qFYod0E7bZHIVhWbW2lJ9Lc6Pt8lHRW58o/KByTROe5QWj7f1EIvaAwBcLWAwv9nLT6en0vzp1Er+isV30lhMvsco3wsG1Z72WDKkEIrrUGaNtr+29ok+ZG3+CpFMIukkpfTGT17ecd2ZjspQYSfuLuMd2VtiEVLD7nWDKMK+Fd5EInRzj0N1PZbx2u9OL/foUpl2C+Jwqah+OLEa2BNZ8bAjthpIQxdnNa+r6GUBMF1Er/2npE5BukbDI83gFK3KMeWboZKf9F2fE9n8EJDk25xE/TJEM/clzm1ADZzYpGZc+y/YYBzjo0BmE6TSEXibykWO5sgpSV9qOim3jNyzz1pD0G/yjkK/z5mHb0kWApN8w4Cu8H4rlXi6s//it8rQyrI1zaFqncy2si05ZfxE+IKm4eiRJmLETPIbqKTxVeGdYgLg4nu4VzbzsnZij9Gwe7bq2E5ArqcgWGrh9nuUgItGw31dClCwW685eASMMXA2wjwR+SUvNmrzIA3zkNdFaegRKn2KNb+kY13spxq8DvNQgKgMI9Fj5QdozMUJw=="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHouSqKncnLZJAgiZ0XSie/pOU12AqH8F7SHL27p0cAF"
  ];
  gaia = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMSJ/Nungq+QFl0Dy1oab4plS6SceTz4TAh/egAjTd+"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCypuBBLeTKtVp6qWQf4V8rYJBqdanL0Ux9M2hTVSZmojNAPWrlMNpfhDzIhApqtR+qESjcebOzvGC63OfNzxEx19facxr2e5i/jM6q2AxDGtcLrhZSugdPd16o7NqTaLSGwLL5jtrXTq4gzfGtr65JsKdHZp6yb2mbsD7dJPt8++KW7wNCVt3sHMx8653AZb5bcI1m+d054uQ8/lBzqMgd4ZOT+K7hQXnqMo7PR8HZ4C0RITNdT36vKoeumvdd7uvKRonQIJzgIE/IWbAfSaeah9mfrST5zVuGs9ZcVCR7KywvWnFiSbX6ZydikWIBgvA5f8jxRM4wks6wNM4YNO6sjhPmw62tPu+5Z3u2P2UqOyhdq0aDi7d5zd6MRKHJB2+WsQiPOkjmVXEKVfJXH5UZAaUAVHazLZw3gLTc+CBXPDaQKfsefGQS3OwNf9rzZF49Xj0Q1WoMGHvJA46rnp5sX6h4ttaE/86xJZlKMY7NWkpFqk9dl54dJGvVAvLCRpm4WkotJ3p9pwFVaQAdURPF70UDTpPjeS8exjvMCZTK3+iNiVTMBUfJnO1DLfGyec14SfiezQoGby47aCd3bCtNoPs4TeUFgD4X1/UmPmQW9sc1mBQx+gAKMrY6I3jMRYfRm5ox0VOYOWvKVRoUg1VDZ2c/SQV9NKqDbTLMEfvOnw=="
  ];
  venus = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILPK1+Tk6AUdpvSp/MDIyCAIOcPxGbiD22jOmWYMx4TJ"
  ];
  astra = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICj5px3xD0TvpCotMUsX/0iBEKfr7mBmHz6/EDZEFjEX"
  ];
  caliban = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDMq7r/kuJACN5FbjvsR7SEq8IStrvYnCn8muj7WzcC"
  ];
  sinope = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjmR3NrvIwMAo19lW/BsoCls28fKQe1yLynfVf2NaSf"
  ];
  rhea = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDupF7apEInSWcUN+Vhio02IdvzdZb0vGxZsghuAttFd"
  ];
  hyperion = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPekfECLzMzhx8LqZ08orVgjCdCGnA5BDKK3Huwdjb8M"
  ];
  ally = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIGVAPgueo3rVUB+JaZwGpD6yl29Vb2OFkCzwa1VrHl"
  ];
  ally2 = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIak2XXCbbSUAmwAvr5aGQ8JMIE54lR7gPGeXJjfV27W"
  ];
  mercury = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMs5X4W+EfqosLHw7g41pH6nAyAN0Ql2XuVKEi3ME1PZ"
  ];
  general = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCXfDasTCd/8qBgVWvhjzbE4XwwTASITR4ucuGlUiKeEQMFh/mfzuobKJlZ9cwppl1C9J9W3HmMrYBmYkEcD2kFqd3KhPZXwwFRg5JXWb46AviNGPul0NrF4IQcmdf6TwTLF3COsMEsL2B5pUjI/axEiQr9JlW6NhGVpi/WEymUgj1FOA4lg3gZ+IcCXCzR7u2b5EqM+ITFn/u1fyYK0lzJcLzaIZbUzicsZnUrFZkDL23GEfMfK6yBLrL0mFa0TzgB5Viu5wUy69RqGOjJqIJXODQ3/v2ciDCkng6LCf2Bw58tdxX6gXMU8/qQ8HJV2zJq0Hccr8wVchbnsSe316DF03RaoT9dIvu1VcguaIpmQGWEKJSM6oo+3AuBVczH1bBpYMxjd4VAah2twTrvrFcDZfQ/THHRT8mYgS7itX2PCQJ0fLW30s+dPLMRzzTgIe6lQBHrRwUbAZIDxrmE8z7lgHz75AlownyyMq5KFtMqB2KrmiKU1Nur5giDwLvXjAMkYiYXyZMhXkPxbHo7vpqQ8AMxL+4qGSWB36hyMShjTnDVe+rFh1KcjTEtZAFjacqDclsa9QRYAoIh4TJTjpJ06OgwfRFeN6VU4Mx0Kaw8Lv2BsUDHdSUoXtNjYHQIRu769bzKOi8hbyxULe9kmv7HIah9cjEAvDD3mPXGu1pgtw=="
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3ySO2ND+Za5z67zWrqMONDXLKBDgOKGuGRXJ2fNKfeN84lPkok/YTNifzvKAFWLB8tvzdQITUV2AaTWt7F33iJpfmJBG1OO2tgsr9SLUpwgthWMrA4FwsFI5/jhw4gQAa5i6R7nkKxOjaXe7BoS82OyIpIhXXpm5TDzMwWelJUBPhYxcDvoZD2BU0SVW3/uFBYIlHsQ5nNyoNtkDf6iJGRF6MlreAI2gyJMcnOm/DxhJ8l1D7BFZ1rPncDCOCn8YnFykp/R58VJBX2dosFaZQr7/17+exDivB4kPlpmWQS74Xej16QsHaqxocS/s0Vj5uQdI8Hk4fLum4yFf5Rxk7"
  ];

  systems =
    agenix
    ++ eris
    ++ neptun
    ++ pluto
    ++ jupiter
    ++ general
    ++ gaia
    ++ venus
    ++ astra
    ++ caliban
    ++ sinope
    ++ rhea
    ++ hyperion
    ++ ally
    ++ ally2
    ++ mercury;
in
{
  # agenix -e id_ecdsa_sk.age
  "id_ecdsa_sk.age".publicKeys = systems;

  # agenix -e nixpkgs-review.age
  "nixpkgs-review.age".publicKeys = systems;

  # agenix -e pia-user.age
  "pia-user.age".publicKeys = systems;

  # agenix -e pia-pass.age
  "pia-pass.age".publicKeys = systems;

  # agenix -e github-token.age
  "github-token.age".publicKeys = systems;

  # agenix -e neosay.age
  "neosay.age".publicKeys = systems;

  # agenix -e atuin.age
  "atuin.age".publicKeys = systems;

  # agenix -e qc-config.age
  "qc-config.age".publicKeys = systems;
}
