{ pkgs }:

pkgs.writeShellScriptBin "Dropterminal" ''
  #!${pkgs.bash}/bin/bash

  # 必要な依存を PATH に追加
  export PATH=${pkgs.hyprland}/bin:${pkgs.jq}/bin:${pkgs.bc}/bin:$PATH

  ${builtins.readFile ./Dropterminal.sh}
''
