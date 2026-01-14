{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "Weather";
  runtimeInputs = [ 
    pkgs.curl 
    pkgs.gnused 
    pkgs.coreutils 
    pkgs.gnugrep
    pkgs.jq # JSONの検証と整形にあると便利
  ];
  checkPhase = "true";
  text = builtins.readFile ./Weather.sh;
}