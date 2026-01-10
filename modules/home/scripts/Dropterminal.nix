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
  text = ''
    if [ $# -eq 0 ]; then
      echo "Usage: dropterminal <terminal>" >&2
      exit 1
    fi
    ${builtins.readFile ./Dropterminal.sh} "$@"
  '';
}