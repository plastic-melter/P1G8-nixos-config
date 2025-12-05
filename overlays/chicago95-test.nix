let
  pkgs = import <nixpkgs> {};
in
pkgs.stdenv.mkDerivation {
  pname = "chicago95";
  version = "unstable-2024-08-07";

  src = pkgs.fetchFromGitHub {
    owner = "grassmunk";
    repo = "Chicago95";
    rev = "6b6ef76c58e2078c913420278b5e17e0aa566374";
    sha256 = "sha256-e0X+rclCM8RCHRllvC/CBizM829dYFNByDGCsU86FqQ=";
  };

  nativeBuildInputs = with pkgs; [ which gzip coreutils ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r GTK-Theme/Chicago95 $out/share/themes/

    mkdir -p $out/share/icons
    cp -r Icons/Chicago95* $out/share/icons/

    mkdir -p $out/share/icons
    cp -r Cursors/* $out/share/icons/
  '';
}

