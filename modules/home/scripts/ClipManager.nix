{ pkgs }:

pkgs.writeShellScriptBin "clipmanager" ''
  #!${pkgs.bash}/bin/bash
  export PATH=${pkgs.rofi}/bin:${pkgs.cliphist}/bin:${pkgs.wl-clipboard}/bin:$PATH
  ${builtins.readFile ./ClipManager.sh}
''
