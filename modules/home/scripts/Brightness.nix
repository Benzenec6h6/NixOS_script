{ pkgs, ... }:

pkgs.writeShellScriptBin "brightness" ''
  #!${pkgs.bash}/bin/bash

  # 依存コマンドを PATH に追加
  export PATH=${pkgs.brightnessctl}/bin:${pkgs.libnotify}/bin:$PATH

  ${builtins.readFile ./Brightness.sh}
''
