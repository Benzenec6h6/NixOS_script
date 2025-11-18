{ pkgs }:

pkgs.writeShellScriptBin "resume-dynamic" ''
  #!/usr/bin/env bash
  export PATH=${pkgs.coreutils}/bin:${pkgs.util-linux}/bin:${pkgs.systemd}/bin:$PATH
  ${builtins.readFile ./resume-dynamic.sh}
''
