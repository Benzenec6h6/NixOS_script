{ pkgs, ... }:

pkgs.writeShellScriptBin "volume" ''
  #!${pkgs.bash}/bin/bash

  # 必要依存をすべて PATH に追加
  export PATH=${pkgs.pamixer}/bin:${pkgs.libnotify}/bin:${pkgs.wireplumber}/bin:${pkgs.pipewire}/bin:${pkgs.alsa-utils}/bin:$PATH

  ${builtins.readFile ./Volume.sh}
''
