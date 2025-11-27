{ pkgs }:

pkgs.writeShellScriptBin "screenshot" ''
  #!${pkgs.bash}/bin/bash
  export PATH=${pkgs.hyprland}/bin:${pkgs.grim}/bin:${pkgs.slurp}/bin:${pkgs.wl-clipboard}/bin:${pkgs.jq}/bin:${pkgs.swappy}/bin:${pkgs.pw-play}/bin:$PATH

  ${builtins.readFile ./ScreenShots.sh}
''
