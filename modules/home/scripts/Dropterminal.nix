{ pkgs }:

pkgs.writeShellApplication {
  name = "Dropterminal";
  runtimeInputs = [ 
    pkgs.hyprland 
    pkgs.jq 
    pkgs.bc 
    pkgs.procps 
    pkgs.coreutils 
    pkgs.gnused
  ];
  checkPhase = "true";
  text = ${builtins.readFile ./Dropterminal.sh};
}