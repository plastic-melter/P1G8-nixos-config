self: super: {
  chicago95 = super.stdenv.mkDerivation {
    pname = "chicago95";
    version = "unstable-2024-08-07";

    src = super.fetchFromGitHub {
      owner = "grassmunk";
      repo = "Chicago95";
      rev = "d975d2323f7631c86e248aa58b9cdb527f8f29ae"; # or use latest commit
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # replace this
    };

    installPhase = ''
      mkdir -p $out/share/themes/Chicago95
      cp -r GTK-Theme/* $out/share/themes/Chicago95

      mkdir -p $out/share/icons/Chicago95-tux
      cp -r Icons/* $out/share/icons/Chicago95-tux

      mkdir -p $out/share/icons/Chicago95-cursors
      cp -r Cursors/* $out/share/icons/Chicago95-cursors
    '';
  };
}

