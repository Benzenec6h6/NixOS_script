{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "sddm-astronaut-theme";
  version = "1.0";

  src = ./sddm-astronaut-theme;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/sddm-astronaut-theme
    cp -r ./* $out/share/sddm/themes/sddm-astronaut-theme/
  '';
}
