{ pkgs }:

pkgs.writeShellScriptBin "killactive" ''
  #!${pkgs.bash}/bin/bash
  export PATH=${pkgs.hyprland}/bin:${pkgs.jq}/bin:$PATH

  ${builtins.readFile ./KillActiveProcess.sh}
''
