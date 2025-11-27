{ pkgs, ... }:

pkgs.writeShellScriptBin "recorder" ''
  #!${pkgs.bash}/bin/bash
  export PATH="${pkgs.wf-recorder}/bin:${pkgs.slurp}/bin:${pkgs.ffmpeg-full}/bin:${pkgs.jq}/bin:$PATH"

  ${builtins.readFile ./recorder.sh}
''
