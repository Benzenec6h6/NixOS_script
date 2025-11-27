{ pkgs }:

pkgs.writeShellScriptBin "clipmanager" ''
  #!${pkgs.bash}/bin/bash
  export PATH=${pkgs.rofi-wayland}/bin:${pkgs.cliphist}/bin:${pkgs.wl-clipboard}/bin:$PATH
  ${builtins.readFile ./ClipManager.sh}
''
