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
    pkgs.kitty # ← あなたが使っているターミナルをここに追加してください
  ];
  checkPhase = "true";
  text = builtins.readFile ./Dropterminal.sh;
}