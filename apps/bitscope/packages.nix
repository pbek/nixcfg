{
  callPackage,
  fetchurl,
}:

let
  mkBitscope = callPackage (import ./common.nix) { };
in
{
  chart =
    let
      toolName = "bitscope-chart";
      version = "1.1.DK05B";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Multi-channel waveform data acquisition and chart recording application";
        homepage = "http://bitscope.com/software/chart/";
      };

      src = fetchurl {
        url = "https://pbek.github.io/bitscope-mirror/download/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-mA8akpPIdGstvDmE59MyRaJU9SetRZQyxUTh+cfyf8I=";
      };
    };

  console =
    let
      toolName = "bitscope-console";
      version = "1.0.FK29A";
    in
    mkBitscope {
      # NOTE: this is meant as a demo by BitScope
      inherit toolName version;

      meta = {
        description = "Demonstrative communications program designed to make it easy to talk to any model BitScope";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "00b4gxwz7w6pmfrcz14326b24kl44hp0gzzqcqxwi5vws3f0y49d";
      };
    };

  display =
    let
      toolName = "bitscope-display";
      version = "1.0.EC17A";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Display diagnostic application for BitScope";
        homepage = "http://bitscope.com/software/display/";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "05xr5mnka1v3ibcasg74kmj6nlv1nmn3lca1wv77whkq85cmz0s1";
      };
    };

  dso =
    let
      toolName = "bitscope-dso";
      version = "2.6.EA17H";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Test and measurement software for BitScope";
        homepage = "http://bitscope.com/software/dso/";
      };

      src = fetchurl {
        url = "https://pbek.github.io/bitscope-mirror/download/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-xbesOnnrr3gkjq7bGIiy/p17oQgcEsg/IEEZ4dujAMQ=";
      };
    };

  logic =
    let
      toolName = "bitscope-logic";
      version = "1.2.DJ20C";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Mixed signal logic timing and serial protocol analysis software for BitScope";
        homepage = "http://bitscope.com/software/logic/";
      };

      src = fetchurl {
        url = "https://pbek.github.io/bitscope-mirror/download/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-KzwgIaX63FRSKd9Smje2Yo0LkgUtXb9EPDkWsa0Q1GE=";
      };
    };

  meter =
    let
      toolName = "bitscope-meter";
      version = "2.0.DK05B";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Automated oscilloscope, voltmeter and frequency meter for BitScope";
        homepage = "http://bitscope.com/software/logic/";
      };

      src = fetchurl {
        url = "https://pbek.github.io/bitscope-mirror/download/${toolName}_${version}_amd64.deb";
        sha256 = "sha256-YtMtlDmjm6DZutJDVcxGM0VupFC/BTHgDGEHDsxJhPQ=";
      };
    };

  proto =
    let
      toolName = "bitscope-proto";
      version = "0.9.FG13B";
    in
    mkBitscope {
      inherit toolName version;
      # NOTE: this is meant as a demo by BitScope
      # NOTE: clicking on logo produces error
      # TApplication.HandleException Executable not found: "http://bitscope.com/blog/DK/?p=DK15A"

      meta = {
        description = "Demonstrative prototype oscilloscope built using the BitScope Library";
        homepage = "http://bitscope.com/blog/DK/?p=DK15A";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "1ybjfbh3narn29ll4nci4b7rnxy0hj3wdfm4v8c6pjr8pfvv9spy";
      };
    };

  server =
    let
      toolName = "bitscope-server";
      version = "1.0.FK26A";
    in
    mkBitscope {
      inherit toolName version;

      meta = {
        description = "Remote access server solution for any BitScope";
        homepage = "http://bitscope.com/software/server/";
      };

      src = fetchurl {
        url = "http://bitscope.com/download/files/${toolName}_${version}_amd64.deb";
        sha256 = "1079n7msq6ks0n4aasx40rd4q99w8j9hcsaci71nd2im2jvjpw9a";
      };
    };
}
